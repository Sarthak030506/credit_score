"""Training script for credit score prediction model."""
import os
import pickle
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import IsolationForest
from xgboost import XGBClassifier
from sklearn.metrics import accuracy_score, roc_auc_score, classification_report

# Path to save model artifacts
DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')


def create_realistic_dataset(n_samples=10000):
    """
    Create a realistic synthetic credit dataset with continuous distributions.
    
    This improves upon the previous discrete "bucket" approach by:
    1. Using continuous distributions for income/limits
    2. modeling utilization as a function of risk profile + noise
    3. Using a probabilistic default model (sigmoid) rather than hard labels
    """
    np.random.seed(42)
    
    # Base latent variable "Credit Health" (0 to 1, higher is better)
    # We'll generate this first and derive other features from it
    # Distribution: Mixture of Gaussians to simulate population tiers but with overlap
    n_tier1 = int(n_samples * 0.4) # Excellent/Good
    n_tier2 = int(n_samples * 0.4) # Fair
    n_tier3 = int(n_samples * 0.2) # Poor
    
    health_tier1 = np.random.normal(0.85, 0.08, n_tier1)
    health_tier2 = np.random.normal(0.50, 0.15, n_tier2) 
    health_tier3 = np.random.normal(0.20, 0.10, n_tier3)
    
    credit_health = np.concatenate([health_tier1, health_tier2, health_tier3])
    credit_health = np.clip(credit_health, 0.01, 0.99)
    np.random.shuffle(credit_health)
    
    data = []
    
    for health in credit_health:
        # 1. LIMIT_BAL: Correlated with health, but also random (income factor)
        # Base limit ranges from 10k to 500k
        base_limit_log = np.random.normal(4.5, 0.5) + (health * 1.5) # Log-normal-ish
        limit = int(10**base_limit_log)
        limit = np.clip(limit, 5000, 800000)
        limit = round(limit, -3) # Round to nearest 1000
        
        # 2. AGE: Slight correlation with health (older -> better history generally), but weak
        age = int(np.random.normal(30 + (health * 15), 10))
        age = np.clip(age, 20, 80)
        
        # 3. Utilization (Inverse to health)
        # High health -> Low utilization (usually < 30%)
        # Low health -> High utilization (often > 80%)
        # Add noise: some rich people have high utilization temporarily
        base_util = 0.8 - (health * 0.7) # 0.8 at health=0, 0.1 at health=1
        util_scen = np.random.normal(base_util, 0.1)
        util_scen = np.clip(util_scen, 0.0, 1.1)
        
        # 4. Payment Behavior (PAY_X)
        # Health > 0.7: mostly -2, -1, 0
        # Health < 0.3: frequent 1, 2, 3+
        payment_probs = np.zeros(6) # [-2, -1, 0, 1, 2, 3+] (mapped to indices 0-5)
        
        if health > 0.8:
            payment_probs = [0.4, 0.4, 0.15, 0.05, 0.0, 0.0]
        elif health > 0.5:
            payment_probs = [0.2, 0.3, 0.3, 0.15, 0.05, 0.0]
        elif health > 0.3:
            payment_probs = [0.05, 0.1, 0.3, 0.3, 0.2, 0.05]
        else:
            payment_probs = [0.0, 0.05, 0.15, 0.3, 0.3, 0.2]
            
        payment_probs = np.array(payment_probs)
        payment_probs /= payment_probs.sum() # Normalize
        
        # Generate 3 months of payment history (correlated)
        pay_statuses = []
        base_status_idx = np.random.choice(6, p=payment_probs)
        for _ in range(3):
            # Slight variation month-to-month
            step = np.random.choice([-1, 0, 1], p=[0.2, 0.6, 0.2])
            curr_idx = np.clip(base_status_idx + step, 0, 5)
            # Map index back to UCI values: 0->-2, 1->-1, 2->0, 3->1, 4->2, 5->3
            val_map = [-2, -1, 0, 1, 2, 3]
            pay_statuses.append(val_map[curr_idx])
            
        # 5. Bill and Pay Amounts
        bill_amt = limit * util_scen
        # Payment Ratio: correlated with health
        # High health pays 100% or more (full balance)
        # Low health pays minimum or less
        pay_ratio_mean = 0.1 + (health * 0.9) # 0.1 to 1.0
        pay_ratio = np.random.normal(pay_ratio_mean, 0.1)
        pay_ratio = np.clip(pay_ratio, 0.0, 1.5)
        
        pay_amt = bill_amt * pay_ratio
        
        # Create row
        row = {
            'LIMIT_BAL': limit,
            'AGE': age,
            'PAY_0': pay_statuses[0],
            'PAY_2': pay_statuses[1],
            'PAY_3': pay_statuses[2],
            'BILL_AMT1': bill_amt,
            'BILL_AMT2': bill_amt * np.random.uniform(0.95, 1.05),
            'BILL_AMT3': bill_amt * np.random.uniform(0.9, 1.1),
            'PAY_AMT1': pay_amt,
            'PAY_AMT2': pay_amt * np.random.uniform(0.9, 1.1),
            'PAY_AMT3': pay_amt * np.random.uniform(0.8, 1.2),
        }
        
        # 6. Default Ground Truth
        # Probability of default depends on health
        # Sigmoid function
        logits = -10 * (health - 0.4) # centered at 0.4
        prob_default = 1 / (1 + np.exp(-logits))
        
        # Add some random noise to the default outcome
        row['default'] = 1 if np.random.random() < prob_default else 0
        
        data.append(row)

    df = pd.DataFrame(data)
    
    # Post-processing: Make sure we don't have impossible values
    df['PAY_AMT1'] = df[['PAY_AMT1', 'LIMIT_BAL']].min(axis=1) # Can't pay more than realistic max (simplified)
    
    return df


def train_anomaly_detector(X_train_scaled):
    """Train Isolation Forest for anomaly detection."""
    iso_forest = IsolationForest(
        n_estimators=100,
        contamination=0.1,  # Expect 10% anomalies
        random_state=42
    )
    iso_forest.fit(X_train_scaled)
    return iso_forest


def train_model():
    """Train XGBoost classifier and anomaly detector, save model artifacts."""
    print("Creating realistic dataset (AUGMENTED)...")
    # Increased sample size to 10,000 for better generalization
    df = create_realistic_dataset(n_samples=10000)

    # Features and target
    feature_cols = ['LIMIT_BAL', 'AGE', 'PAY_0', 'PAY_2', 'PAY_3',
                    'BILL_AMT1', 'BILL_AMT2', 'BILL_AMT3',
                    'PAY_AMT1', 'PAY_AMT2', 'PAY_AMT3']

    X = df[feature_cols]
    y = df['default']

    print(f"Dataset shape: {X.shape}")
    print(f"Default rate: {y.mean():.2%}")
    print(f"Class distribution: 0={len(y[y==0])}, 1={len(y[y==1])}")

    # Split data
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42, stratify=y
    )

    # Scale features
    print("\nScaling features...")
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)

    # Train anomaly detector
    print("Training anomaly detector...")
    anomaly_detector = train_anomaly_detector(X_train_scaled)

    # Train XGBoost classifier with balanced class weights
    print("Training XGBoost model...")

    # Calculate scale_pos_weight for imbalanced classes
    scale_pos_weight = len(y_train[y_train == 0]) / len(y_train[y_train == 1])

    model = XGBClassifier(
        n_estimators=150,
        max_depth=6,
        learning_rate=0.1,
        scale_pos_weight=scale_pos_weight,
        random_state=42,
        eval_metric='logloss'
    )
    model.fit(X_train_scaled, y_train)

    # Evaluate
    y_pred = model.predict(X_test_scaled)
    y_prob = model.predict_proba(X_test_scaled)[:, 1]

    print("\n" + "="*50)
    print("Model Evaluation:")
    print("="*50)
    print(f"Accuracy: {accuracy_score(y_test, y_pred):.4f}")
    print(f"ROC-AUC: {roc_auc_score(y_test, y_prob):.4f}")
    print("\nClassification Report:")
    print(classification_report(y_test, y_pred, target_names=['No Default', 'Default']))

    # Test probability distribution
    print("\nPrediction probability distribution:")
    print(f"  Min prob: {y_prob.min():.4f}")
    print(f"  Max prob: {y_prob.max():.4f}")
    print(f"  Mean prob: {y_prob.mean():.4f}")
    print(f"  Median prob: {np.median(y_prob):.4f}")

    # Save model artifacts
    os.makedirs(DATA_DIR, exist_ok=True)

    model_path = os.path.join(DATA_DIR, 'model.pkl')
    scaler_path = os.path.join(DATA_DIR, 'scaler.pkl')
    feature_names_path = os.path.join(DATA_DIR, 'feature_names.pkl')
    anomaly_path = os.path.join(DATA_DIR, 'anomaly_detector.pkl')

    with open(model_path, 'wb') as f:
        pickle.dump(model, f)
    print(f"\nModel saved to: {model_path}")

    with open(scaler_path, 'wb') as f:
        pickle.dump(scaler, f)
    print(f"Scaler saved to: {scaler_path}")

    with open(feature_names_path, 'wb') as f:
        pickle.dump(feature_cols, f)
    print(f"Feature names saved to: {feature_names_path}")

    with open(anomaly_path, 'wb') as f:
        pickle.dump(anomaly_detector, f)
    print(f"Anomaly detector saved to: {anomaly_path}")

    return model, scaler, anomaly_detector, feature_cols


if __name__ == '__main__':
    train_model()
