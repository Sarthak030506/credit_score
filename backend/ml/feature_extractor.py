"""Feature extraction from transaction data."""
import pandas as pd
import numpy as np
from typing import Dict, List, Any


class FeatureExtractor:
    """Extract credit-relevant features from transaction data."""

    # Expected columns in transaction CSV
    EXPECTED_COLUMNS = ['date', 'amount', 'category', 'type', 'balance']

    def __init__(self):
        """Initialize the feature extractor."""
        self.features = {}

    def extract_features(self, transactions: List[Dict[str, Any]]) -> Dict[str, float]:
        """
        Extract features from a list of transactions.

        Args:
            transactions: List of transaction dictionaries with keys:
                - date: Transaction date
                - amount: Transaction amount
                - category: Category (groceries, utilities, salary, etc.)
                - type: 'credit' or 'debit'
                - balance: Account balance after transaction

        Returns:
            Dictionary of extracted features mapped to model input format.
        """
        if not transactions:
            return self._get_default_features()

        df = pd.DataFrame(transactions)

        # Convert date to datetime
        df['date'] = pd.to_datetime(df['date'], errors='coerce')
        df['amount'] = pd.to_numeric(df['amount'], errors='coerce').fillna(0)
        df['balance'] = pd.to_numeric(df['balance'], errors='coerce').fillna(0)

        # Sort by date
        df = df.sort_values('date')

        # Extract raw features
        features = {}

        # Income-related features
        income_txns = df[df['type'].str.lower() == 'credit']
        expense_txns = df[df['type'].str.lower() == 'debit']

        total_income = income_txns['amount'].sum() if len(income_txns) > 0 else 0
        total_expenses = expense_txns['amount'].sum() if len(expense_txns) > 0 else 0

        # Helper to handle NaN values
        def safe_float(val, default=0.0):
            if pd.isna(val) or np.isnan(val) if isinstance(val, float) else False:
                return default
            return float(val)

        features['transaction_count'] = len(df)
        features['avg_transaction'] = safe_float(df['amount'].mean(), 500)
        amt_std = df['amount'].std()
        amt_mean = df['amount'].mean()
        features['transaction_volatility'] = safe_float(amt_std / (amt_mean + 1), 0.5) if amt_mean > 0 else 0.5
        features['expense_ratio'] = safe_float(total_expenses / (total_income + 1), 1.0) if total_income > 0 else 1.0

        # Payment consistency (Max days between payments)
        # Standard deviation penalizes freelance/irregular payers.
        # Max gap is better: 35 days = OK, 60 days = Missed a month.
        max_payment_gap = 30.0  # default
        if len(income_txns) > 1:
            income_dates = income_txns['date'].dropna()
            if len(income_dates) > 1:
                # diff() gives days between adjacent payments
                date_diffs = income_dates.diff().dropna().dt.days
                if len(date_diffs) > 0:
                    max_payment_gap = float(date_diffs.max())
        features['payment_consistency'] = max_payment_gap

        # Overdraft frequency (balance going negative)
        features['overdraft_frequency'] = safe_float((df['balance'] < 0).sum() / len(df), 0) if len(df) > 0 else 0

        # Income stability (coefficient of variation of income)
        if len(income_txns) > 1:
            inc_std = income_txns['amount'].std()
            inc_mean = income_txns['amount'].mean()
            features['income_stability'] = safe_float(inc_std / (inc_mean + 1), 0.5)
        else:
            features['income_stability'] = 0.5

        # Category diversity (more diverse = better financial management)
        unique_categories = df['category'].nunique() if 'category' in df.columns else 1
        features['category_diversity'] = min(unique_categories / 10, 1.0)

        # Account age (days between first and last transaction)
        if len(df) > 1 and df['date'].notna().any():
            date_range = (df['date'].max() - df['date'].min()).days
            features['account_age'] = safe_float(date_range, 30)
        else:
            features['account_age'] = 30

        # Average balance
        features['avg_balance'] = safe_float(df['balance'].mean(), 5000)

        # Map to model input format
        return self._map_to_model_features(features, total_income, total_expenses)

    def _map_to_model_features(self, features: Dict[str, float],
                                total_income: float,
                                total_expenses: float) -> Dict[str, float]:
        """
        Map extracted features to the model's expected input format.

        Maps transaction-based features to UCI Credit Card features.
        """
        # Estimate credit limit based on income and stability
        # Stable income (low volatility) suggests higher creditworthiness/limit
        volatility = features.get('transaction_volatility', 0.5)
        
        # Multiplier ranges from 3x (unstable) to 10x (very stable)
        limit_multiplier = max(3.0, 10.0 - (volatility * 10))
        estimated_limit = max(total_income * limit_multiplier, 30000) # Floor at 30k

        # Convert payment consistency (max gap) to payment status
        # PAY_0: -1 = pay on time, 0 = revolving, 1 = late 1 month, etc.
        # -2: No consumption (unused) or full payment
        max_gap = features['payment_consistency']
        
        # Payment Status Mapping
        if max_gap <= 32:
            payment_status = -1  # Paid on time
        elif max_gap <= 40:
            payment_status = 0   # Revolving credit (paid minimum but not full?)
        elif max_gap <= 65:
            payment_status = 1   # 1 month late
        elif max_gap <= 95:
            payment_status = 2   # 2 months late
        else:
            payment_status = min(int(max_gap / 30), 8) # Cap at 8
            
        # Refine payment status with overdraft data
        # If they overdraft frequently, they are likely struggling
        if features.get('overdraft_frequency', 0) > 0.2:
            payment_status = max(payment_status, 2)

        # Calculate bill amounts based on expenses and balance
        # We assume bills are roughly equal to expenses
        bill_amt = total_expenses / 3 if total_expenses > 0 else features['avg_balance'] * 0.3

        # Calculate payment amounts based on income patterns
        # If income > expenses, they likely pay full bill
        # If income < expenses, they pay only a portion
        if total_income > total_expenses:
             pay_amt = bill_amt * 1.05 # Paying full + extra
        else:
             pay_amt = bill_amt * (total_income / (total_expenses + 1))

        model_features = {
            'LIMIT_BAL': estimated_limit,
            'AGE': 35,  # Default age
            'PAY_0': payment_status,
            'PAY_2': payment_status,
            'PAY_3': payment_status,
            'BILL_AMT1': bill_amt,
            'BILL_AMT2': bill_amt * 0.95,
            'BILL_AMT3': bill_amt * 0.9,
            'PAY_AMT1': pay_amt,
            'PAY_AMT2': pay_amt * 0.95,
            'PAY_AMT3': pay_amt * 0.9,
        }

        # Store raw features for explanations
        model_features['_raw_features'] = features

        return model_features

    def _get_default_features(self) -> Dict[str, float]:
        """Return default features when no transactions are provided."""
        return {
            'LIMIT_BAL': 50000,
            'AGE': 35,
            'PAY_0': 0,
            'PAY_2': 0,
            'PAY_3': 0,
            'BILL_AMT1': 10000,
            'BILL_AMT2': 9500,
            'BILL_AMT3': 9000,
            'PAY_AMT1': 5000,
            'PAY_AMT2': 4750,
            'PAY_AMT3': 4500,
            '_raw_features': {
                'avg_transaction': 500,
                'transaction_volatility': 0.5,
                'expense_ratio': 0.8,
                'payment_consistency': 7,
                'overdraft_frequency': 0,
                'income_stability': 0.3,
                'category_diversity': 0.5,
                'account_age': 180,
                'avg_balance': 5000
            }
        }


def parse_csv_transactions(csv_content: str) -> List[Dict[str, Any]]:
    """
    Parse CSV content into a list of transaction dictionaries.

    Args:
        csv_content: CSV string with transaction data

    Returns:
        List of transaction dictionaries
    """
    from io import StringIO

    try:
        df = pd.read_csv(StringIO(csv_content))

        # Normalize column names
        df.columns = df.columns.str.lower().str.strip()

        # Map common column name variations
        column_mapping = {
            'transaction_date': 'date',
            'trans_date': 'date',
            'transaction_amount': 'amount',
            'trans_amount': 'amount',
            'transaction_type': 'type',
            'trans_type': 'type',
            'account_balance': 'balance',
            'running_balance': 'balance',
            'transaction_category': 'category',
            'trans_category': 'category'
        }

        df = df.rename(columns=column_mapping)

        # Ensure required columns exist
        required = ['date', 'amount', 'type']
        for col in required:
            if col not in df.columns:
                # Try to infer from data
                if col == 'type' and 'amount' in df.columns:
                    df['type'] = df['amount'].apply(lambda x: 'credit' if x > 0 else 'debit')
                elif col == 'date':
                    df['date'] = pd.Timestamp.now().strftime('%Y-%m-%d')
                else:
                    df[col] = 0

        # Ensure optional columns exist
        if 'category' not in df.columns:
            df['category'] = 'other'
        if 'balance' not in df.columns:
            df['balance'] = df['amount'].cumsum()

        return df.to_dict('records')

    except Exception as e:
        print(f"Error parsing CSV: {e}")
        return []
