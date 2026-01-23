"""Credit score prediction module."""
import os
import pickle
import numpy as np
from typing import Dict, Any, Tuple

from config import Config


class CreditScorePredictor:
    """Predicts credit score from features."""

    def __init__(self):
        """Initialize the predictor with trained model and scaler."""
        self.model = None
        self.scaler = None
        self.feature_names = None
        self._load_model()

    def _load_model(self):
        """Load the trained model and scaler from disk."""
        try:
            with open(Config.MODEL_PATH, 'rb') as f:
                self.model = pickle.load(f)

            with open(Config.SCALER_PATH, 'rb') as f:
                self.scaler = pickle.load(f)

            feature_names_path = Config.MODEL_PATH.replace('model.pkl', 'feature_names.pkl')
            with open(feature_names_path, 'rb') as f:
                self.feature_names = pickle.load(f)

        except FileNotFoundError as e:
            print(f"Model files not found: {e}")
            print("Please run train_model.py first.")
            self.model = None
            self.scaler = None
            self.feature_names = ['LIMIT_BAL', 'AGE', 'PAY_0', 'PAY_2', 'PAY_3',
                                   'BILL_AMT1', 'BILL_AMT2', 'BILL_AMT3',
                                   'PAY_AMT1', 'PAY_AMT2', 'PAY_AMT3']

    def predict(self, features: Dict[str, float]) -> Dict[str, Any]:
        """
        Predict credit score from features.

        Args:
            features: Dictionary of features from FeatureExtractor

        Returns:
            Dictionary containing:
                - score: Credit score (300-850)
                - category: Risk category (Excellent/Good/Fair/Poor)
                - probability_of_default: Default probability (0-1)
                - feature_values: Feature values used for prediction
        """
        # Extract raw features for explanations
        raw_features = features.pop('_raw_features', {})

        # Prepare feature vector
        feature_vector = self._prepare_feature_vector(features)

        if self.model is None:
            # Return mock prediction if model not loaded
            return self._mock_prediction(features, raw_features)

        # Scale features
        feature_vector_scaled = self.scaler.transform([feature_vector])

        # Get default probability
        default_prob = float(self.model.predict_proba(feature_vector_scaled)[0][1])

        # Convert to credit score (inverse of default probability)
        score = self._probability_to_score(default_prob)

        # Business Logic Overrides:
        # Ensure logical consistency - Late payments should prevent "Good" scores
        pay_status = features.get('PAY_0', 0)
        
        if pay_status > 0:
            # If late (status 1+), cap at 660 (Start of Good range is 670)
            score = min(score, 660)
            
        if pay_status >= 2:
            # If 2+ months late, cap at 579 (End of Poor range is 579)
            score = min(score, 579)

        # Determine risk category
        category = self._get_risk_category(score)

        # Convert all numpy types to Python native types for JSON serialization
        clean_features = {k: float(v) if hasattr(v, 'item') else v for k, v in features.items()}
        clean_raw = {k: float(v) if hasattr(v, 'item') else v for k, v in raw_features.items()}
        clean_vector = [float(x) if hasattr(x, 'item') else x for x in feature_vector]

        if pay_status >= 2:
            # If 2+ months late, cap at 579 (End of Poor range is 579)
            score = min(score, 579)

        # Overdraft Penalties
        overdraft_freq = raw_features.get('overdraft_frequency', 0)
        if overdraft_freq > 0.2:
            score = min(score, 550) # Very high risk
        elif overdraft_freq > 0.1:
            score = min(score, 620) # Fair only
        elif overdraft_freq > 0:
            score = min(score, 740) # Cannot be Excellent

        # Volatility Penalties
        volatility = raw_features.get('transaction_volatility', 0)
        if volatility > 1.0:
            score = min(score, 720) # Stable income is preferred

        # Expense Ratio Penalties
        expense_ratio = raw_features.get('expense_ratio', 0)
        if expense_ratio > 0.95:
             score = min(score, 650) # Living paycheck to paycheck

        return {
            'score': int(score),
            'category': self._get_risk_category(score),
            'probability_of_default': round(float(default_prob), 4),
            'feature_values': clean_features,
            'raw_features': clean_raw,
            'feature_vector': clean_vector
        }

    def _prepare_feature_vector(self, features: Dict[str, float]) -> list:
        """Prepare feature vector in correct order for model."""
        return [features.get(name, 0) for name in self.feature_names]

    def _probability_to_score(self, default_prob: float) -> int:
        """
        Convert default probability to credit score (300-850).

        Lower default probability = higher credit score.
        """
        # Invert probability and scale to credit score range
        score = Config.SCORE_MIN + (1 - default_prob) * (Config.SCORE_MAX - Config.SCORE_MIN)
        return int(round(score))

    def _get_risk_category(self, score: int) -> str:
        """Determine risk category based on score."""
        for category, (min_score, max_score) in Config.RISK_CATEGORIES.items():
            if min_score <= score <= max_score:
                return category
        return 'Poor'

    def _mock_prediction(self, features: Dict[str, float],
                         raw_features: Dict[str, float]) -> Dict[str, Any]:
        """
        Generate mock prediction when model is not available.

        Uses heuristics based on payment history and balance.
        """
        # Calculate mock default probability based on features
        pay_status = features.get('PAY_0', 0)
        bill_amt = features.get('BILL_AMT1', 0)
        pay_amt = features.get('PAY_AMT1', 0)
        limit = features.get('LIMIT_BAL', 50000)

        # Higher payment delay status = higher default risk
        pay_risk = max(0, pay_status) / 6

        # Higher utilization = higher risk
        utilization = bill_amt / (limit + 1)

        # Lower payment ratio = higher risk
        payment_ratio = pay_amt / (bill_amt + 1)

        # Combine factors
        default_prob = (pay_risk * 0.4 + utilization * 0.3 + (1 - min(payment_ratio, 1)) * 0.3)
        default_prob = min(max(default_prob, 0.05), 0.95)

        score = self._probability_to_score(default_prob)
        category = self._get_risk_category(score)

        return {
            'score': score,
            'category': category,
            'probability_of_default': round(default_prob, 4),
            'feature_values': features,
            'raw_features': raw_features,
            'feature_vector': self._prepare_feature_vector(features)
        }


# Singleton instance
_predictor = None


def get_predictor() -> CreditScorePredictor:
    """Get or create the singleton predictor instance."""
    global _predictor
    if _predictor is None:
        _predictor = CreditScorePredictor()
    return _predictor
