"""Explainability module using SHAP for credit score explanations."""
import numpy as np
from typing import Dict, List, Any
import os
import pickle

try:
    import shap
    SHAP_AVAILABLE = True
except ImportError:
    SHAP_AVAILABLE = False

from config import Config


class CreditScoreExplainer:
    """Generate explanations for credit score predictions using SHAP."""

    # Human-readable feature names
    FEATURE_DESCRIPTIONS = {
        'LIMIT_BAL': 'Credit limit',
        'AGE': 'Account age',
        'PAY_0': 'Recent payment status',
        'PAY_2': 'Payment status (2 months ago)',
        'PAY_3': 'Payment status (3 months ago)',
        'BILL_AMT1': 'Recent bill amount',
        'BILL_AMT2': 'Bill amount (2 months ago)',
        'BILL_AMT3': 'Bill amount (3 months ago)',
        'PAY_AMT1': 'Recent payment amount',
        'PAY_AMT2': 'Payment amount (2 months ago)',
        'PAY_AMT3': 'Payment amount (3 months ago)',
    }

    # Raw feature descriptions
    RAW_FEATURE_DESCRIPTIONS = {
        'avg_transaction': 'Average transaction size',
        'transaction_volatility': 'Spending consistency',
        'expense_ratio': 'Expense to income ratio',
        'payment_consistency': 'Payment timing consistency',
        'overdraft_frequency': 'Overdraft occurrences',
        'income_stability': 'Income regularity',
        'category_diversity': 'Spending diversity',
        'account_age': 'Account history length',
        'avg_balance': 'Average account balance'
    }

    def __init__(self):
        """Initialize the explainer."""
        self.model = None
        self.scaler = None
        self.explainer = None
        self._load_model()

    def _load_model(self):
        """Load model for SHAP explainer."""
        try:
            with open(Config.MODEL_PATH, 'rb') as f:
                self.model = pickle.load(f)
            with open(Config.SCALER_PATH, 'rb') as f:
                self.scaler = pickle.load(f)

            if SHAP_AVAILABLE and self.model is not None:
                self.explainer = shap.TreeExplainer(self.model)
        except FileNotFoundError:
            pass

    def explain(self, feature_vector: List[float],
                feature_values: Dict[str, float],
                raw_features: Dict[str, float] = None) -> Dict[str, Any]:
        """
        Generate explanations for a prediction.

        Args:
            feature_vector: Scaled feature vector used for prediction
            feature_values: Original feature values (unscaled)
            raw_features: Raw extracted features for additional context

        Returns:
            Dictionary containing positive and negative factors
        """
        if SHAP_AVAILABLE and self.explainer is not None:
            return self._shap_explanation(feature_vector, feature_values, raw_features)
        else:
            return self._heuristic_explanation(feature_values, raw_features)

    def _shap_explanation(self, feature_vector: List[float],
                          feature_values: Dict[str, float],
                          raw_features: Dict[str, float]) -> Dict[str, Any]:
        """Generate SHAP-based explanation."""
        # Scale features
        scaled_vector = self.scaler.transform([feature_vector])

        # Get SHAP values
        shap_values = self.explainer.shap_values(scaled_vector)

        # Handle different SHAP output formats
        if isinstance(shap_values, list):
            # Binary classification: use class 1 (default) values
            values = shap_values[1][0] if len(shap_values) > 1 else shap_values[0][0]
        else:
            values = shap_values[0]

        # Create feature importance pairs
        feature_names = list(self.FEATURE_DESCRIPTIONS.keys())
        importance = list(zip(feature_names, values))

        # Sort by absolute importance
        importance.sort(key=lambda x: abs(x[1]), reverse=True)

        # Split into positive and negative factors
        # Note: For default prediction, positive SHAP = higher default risk = negative for credit
        positive_factors = []
        negative_factors = []

        for feature, value in importance[:6]:  # Top 6 factors
            description = self.FEATURE_DESCRIPTIONS.get(feature, feature)
            feature_value = feature_values.get(feature, 0)

            # Format the explanation
            if value < 0:  # Negative SHAP = reduces default risk = good for credit
                positive_factors.append(self._format_positive_factor(feature, feature_value, abs(value)))
            else:  # Positive SHAP = increases default risk = bad for credit
                negative_factors.append(self._format_negative_factor(feature, feature_value, abs(value)))

        # Add raw feature insights if available
        if raw_features:
            self._add_raw_feature_insights(positive_factors, negative_factors, raw_features)

        return {
            'positive': positive_factors[:3],
            'negative': negative_factors[:3],
            'feature_importance': {feature: float(value) for feature, value in importance}
        }

    def _heuristic_explanation(self, feature_values: Dict[str, float],
                                raw_features: Dict[str, float]) -> Dict[str, Any]:
        """Generate explanation using heuristics when SHAP is not available."""
        positive_factors = []
        negative_factors = []

        # Analyze payment status
        pay_0 = feature_values.get('PAY_0', 0)
        if pay_0 <= 0:
            positive_factors.append("On-time payment history")
        elif pay_0 >= 2:
            negative_factors.append("Recent late payments detected")

        # Analyze payment consistency (max gap)
        payment_consistency = raw_features.get('payment_consistency', 30)
        if payment_consistency <= 35:
             if "Consistent payment schedule" not in str(positive_factors):
                positive_factors.append("Consistent payment schedule")
        elif payment_consistency > 60:
            negative_factors.append("Irregular payment gaps > 60 days")

        # Analyze credit utilization
        bill = feature_values.get('BILL_AMT1', 0)
        limit = feature_values.get('LIMIT_BAL', 1)
        utilization = bill / limit if limit > 0 else 0

        if utilization < 0.3:
            positive_factors.append("Low credit utilization ratio")
        elif utilization > 0.7:
            negative_factors.append("High credit utilization ratio")

        # Analyze payment amounts
        pay_amt = feature_values.get('PAY_AMT1', 0)
        if pay_amt > bill * 0.5:
            positive_factors.append("Strong payment amounts relative to balance")
        elif pay_amt < bill * 0.1:
            negative_factors.append("Low payment amounts relative to balance")

        # Add raw feature insights
        if raw_features:
            self._add_raw_feature_insights(positive_factors, negative_factors, raw_features)

        # Ensure we have at least one factor in each category
        if not positive_factors:
            positive_factors.append("Account in good standing")
        if not negative_factors:
            negative_factors.append("No significant negative factors")

        return {
            'positive': positive_factors[:3],
            'negative': negative_factors[:3],
            'feature_importance': {}
        }

    def _format_positive_factor(self, feature: str, value: float, importance: float) -> str:
        """Format a positive factor explanation."""
        desc = self.FEATURE_DESCRIPTIONS.get(feature, feature)

        if feature.startswith('PAY_') and feature != 'PAY_AMT1':
            if value <= 0:
                return "Consistent on-time payments"
        elif feature == 'LIMIT_BAL':
            return f"Good credit limit of ${value:,.0f}"
        elif feature.startswith('PAY_AMT'):
            return f"Strong payment amounts"

        return f"Good {desc.lower()}"

    def _format_negative_factor(self, feature: str, value: float, importance: float) -> str:
        """Format a negative factor explanation."""
        desc = self.FEATURE_DESCRIPTIONS.get(feature, feature)

        if feature.startswith('PAY_') and feature != 'PAY_AMT1':
            if value > 0:
                return f"Payment delays detected ({int(value)} months late)"
        elif feature.startswith('BILL_AMT'):
            return "High outstanding balance"
        elif feature.startswith('PAY_AMT'):
            return "Low payment amounts"

        return f"Consider improving {desc.lower()}"

    def _add_raw_feature_insights(self, positive: List[str], negative: List[str],
                                   raw_features: Dict[str, float]):
        """Add insights from raw transaction features."""
        # Check overdraft frequency
        overdraft = raw_features.get('overdraft_frequency', 0)
        if overdraft == 0:
            if "No overdrafts" not in str(positive):
                positive.append("No overdraft occurrences")
        elif overdraft > 0.1:
            negative.append("Frequent overdrafts detected")

        # Check income stability
        income_stability = raw_features.get('income_stability', 0.5)
        if income_stability < 0.3:
            positive.append("Stable, consistent income")
        elif income_stability > 0.7:
            negative.append("Irregular income patterns")

        # Check expense ratio
        expense_ratio = raw_features.get('expense_ratio', 0.8)
        if expense_ratio < 0.6:
            positive.append("Good savings rate")
        elif expense_ratio > 0.95:
            negative.append("High expense-to-income ratio")


# Singleton instance
_explainer = None


def get_explainer() -> CreditScoreExplainer:
    """Get or create the singleton explainer instance."""
    global _explainer
    if _explainer is None:
        _explainer = CreditScoreExplainer()
    return _explainer
