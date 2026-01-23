"""Counterfactual explanation module for improvement suggestions."""
from typing import Dict, List, Any
import numpy as np


class CounterfactualGenerator:
    """Generate actionable improvement suggestions based on feature gaps."""

    # Target values for a "good" credit profile
    GOOD_PROFILE = {
        'PAY_0': -1,  # Paid early
        'PAY_2': -1,
        'PAY_3': -1,
        'utilization': 0.4,  # 40% credit utilization (was 30%)
        'payment_ratio': 0.8,  # Pay 80% of bill
        'expense_ratio': 0.7,  # Spend 70% of income
        'overdraft_frequency': 0,
        'income_stability': 0.2,  # Low variance
        'transaction_volatility': 0.3,
    }

    # Impact estimates for improvements (points)
    IMPROVEMENT_IMPACTS = {
        'payment_status': 50,
        'utilization': 40,
        'payment_amount': 35,
        'expense_ratio': 30,
        'overdraft': 25,
        'income_stability': 20,
        'spending_consistency': 15,
    }

    # Improvement suggestions templates
    SUGGESTIONS = {
        'payment_status': {
            'action': 'Make all payments on time',
            'detail': 'Set up automatic payments to avoid late fees and negative marks',
            'timeline': '3-6 months',
        },
        'utilization': {
            'action': 'Reduce credit utilization',
            'detail': 'Keep balances below 30% of your credit limit',
            'timeline': '1-3 months',
        },
        'payment_amount': {
            'action': 'Increase monthly payments',
            'detail': 'Pay more than the minimum - aim for at least 50% of balance',
            'timeline': '2-4 months',
        },
        'expense_ratio': {
            'action': 'Reduce expense-to-income ratio',
            'detail': 'Create a budget to track and reduce non-essential spending',
            'timeline': '1-3 months',
        },
        'overdraft': {
            'action': 'Eliminate overdrafts',
            'detail': 'Maintain a buffer in your account and set up low balance alerts',
            'timeline': '1-2 months',
        },
        'income_stability': {
            'action': 'Stabilize income patterns',
            'detail': 'Consider regular income sources or consistent freelance scheduling',
            'timeline': '3-6 months',
        },
        'spending_consistency': {
            'action': 'Reduce spending volatility',
            'detail': 'Smooth out large purchases over time when possible',
            'timeline': '2-4 months',
        },
    }

    def generate_improvements(self, feature_values: Dict[str, float],
                               raw_features: Dict[str, float],
                               current_score: int) -> List[Dict[str, Any]]:
        """
        Generate prioritized improvement suggestions.

        Args:
            feature_values: Model feature values
            raw_features: Raw extracted features
            current_score: Current credit score

        Returns:
            List of improvement suggestions with estimated impact
        """
        improvements = []

        # Analyze payment status
        pay_0 = feature_values.get('PAY_0', 0)
        if pay_0 > 0:
            impact = self._calculate_impact('payment_status', pay_0, 0)
            improvements.append({
                **self.SUGGESTIONS['payment_status'],
                'impact': f"+{impact} points",
                'impact_value': impact,
                'priority': 'high' if pay_0 >= 2 else 'medium',
                'current': f"{pay_0} months late",
                'target': 'On-time payments'
            })

        # Analyze credit utilization
        bill = feature_values.get('BILL_AMT1', 0)
        limit = feature_values.get('LIMIT_BAL', 1)
        utilization = bill / limit if limit > 0 else 0

        if utilization > 0.3:
            impact = self._calculate_impact('utilization', utilization, 0.3)
            improvements.append({
                **self.SUGGESTIONS['utilization'],
                'impact': f"+{impact} points",
                'impact_value': impact,
                'priority': 'high' if utilization > 0.7 else 'medium',
                'current': f"{utilization:.0%} utilization",
                'target': '30% utilization'
            })

        # Analyze payment amounts
        pay_amt = feature_values.get('PAY_AMT1', 0)
        payment_ratio = pay_amt / bill if bill > 0 else 1

        if payment_ratio < 0.5:
            impact = self._calculate_impact('payment_amount', payment_ratio, 0.5)
            improvements.append({
                **self.SUGGESTIONS['payment_amount'],
                'impact': f"+{impact} points",
                'impact_value': impact,
                'priority': 'medium',
                'current': f"Paying {payment_ratio:.0%} of balance",
                'target': 'Pay 50%+ of balance'
            })

        # Analyze raw features if available
        if raw_features:
            # Expense ratio
            expense_ratio = raw_features.get('expense_ratio', 0.8)
            if expense_ratio > 0.85:
                impact = self._calculate_impact('expense_ratio', expense_ratio, 0.7)
                improvements.append({
                    **self.SUGGESTIONS['expense_ratio'],
                    'impact': f"+{impact} points",
                    'impact_value': impact,
                    'priority': 'medium',
                    'current': f"{expense_ratio:.0%} expense ratio",
                    'target': '70% expense ratio'
                })

            # Overdrafts
            overdraft = raw_features.get('overdraft_frequency', 0)
            if overdraft > 0:
                impact = self._calculate_impact('overdraft', overdraft, 0)
                improvements.append({
                    **self.SUGGESTIONS['overdraft'],
                    'impact': f"+{impact} points",
                    'impact_value': impact,
                    'priority': 'high',
                    'current': f"{overdraft:.0%} transactions overdraft",
                    'target': 'No overdrafts'
                })

            # Income stability
            income_stability = raw_features.get('income_stability', 0.5)
            if income_stability > 0.5:
                impact = self._calculate_impact('income_stability', income_stability, 0.2)
                improvements.append({
                    **self.SUGGESTIONS['income_stability'],
                    'impact': f"+{impact} points",
                    'impact_value': impact,
                    'priority': 'low',
                    'current': 'Variable income',
                    'target': 'Stable income'
                })

            # Spending consistency
            volatility = raw_features.get('transaction_volatility', 0.5)
            if volatility > 0.5:
                impact = self._calculate_impact('spending_consistency', volatility, 0.3)
                improvements.append({
                    **self.SUGGESTIONS['spending_consistency'],
                    'impact': f"+{impact} points",
                    'impact_value': impact,
                    'priority': 'low',
                    'current': 'High spending volatility',
                    'target': 'Consistent spending'
                })

        # Sort by impact value (highest first)
        improvements.sort(key=lambda x: x['impact_value'], reverse=True)

        # Add potential score after improvements
        total_potential = sum(i['impact_value'] for i in improvements[:3])
        for imp in improvements:
            imp['potential_score'] = min(current_score + imp['impact_value'], 850)

        return improvements

    def _calculate_impact(self, improvement_type: str,
                          current_value: float,
                          target_value: float) -> int:
        """Calculate estimated score impact for an improvement."""
        base_impact = self.IMPROVEMENT_IMPACTS.get(improvement_type, 20)

        # Scale impact by how far from target
        if improvement_type in ['utilization', 'expense_ratio', 'income_stability',
                                 'spending_consistency', 'overdraft']:
            # For these, lower is better
            gap = max(0, current_value - target_value)
            scale = min(gap / 0.5, 1.0)  # Max scale at 50% gap
        else:
            # For payment status, higher deviation is worse
            gap = abs(current_value - target_value)
            scale = min(gap / 3, 1.0)  # Max scale at 3 months late

        return int(base_impact * (0.5 + 0.5 * scale))


# Singleton instance
_generator = None


def get_counterfactual_generator() -> CounterfactualGenerator:
    """Get or create the singleton generator instance."""
    global _generator
    if _generator is None:
        _generator = CounterfactualGenerator()
    return _generator
