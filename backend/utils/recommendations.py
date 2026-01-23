"""Role-based recommendation engine."""
import os
import requests
from typing import Dict, Any, List

from config import Config


class RecommendationEngine:
    """Generate role-specific recommendations based on credit assessment."""

    # Credit limit multipliers by risk level
    CREDIT_LIMIT_MULTIPLIERS = {
        'Excellent': 3.5,
        'Very Good': 3.0,
        'Good': 2.0,
        'Fair': 1.0,
        'Poor': 0.5
    }

    # Interest rate tiers
    INTEREST_RATE_TIERS = {
        'Excellent': 'A+',  # Prime rates
        'Very Good': 'A',
        'Good': 'B',
        'Fair': 'C',
        'Poor': 'D'  # Highest rates
    }

    # Bank decision mapping
    BANK_DECISIONS = {
        'Excellent': 'APPROVE',
        'Very Good': 'APPROVE',
        'Good': 'APPROVE',
        'Fair': 'APPROVE_WITH_CONDITIONS',
        'Poor': 'MANUAL_REVIEW'
    }

    def generate_citizen_recommendations(self, score: int, category: str,
                                          explanations: Dict[str, List[str]],
                                          improvements: List[Dict[str, Any]]) -> Dict[str, Any]:
        """
        Generate recommendations for citizens.

        Args:
            score: Credit score
            category: Risk category
            explanations: Positive and negative factors
            improvements: List of improvement suggestions

        Returns:
            Citizen-focused recommendations
        """
        # Generate narrative explanation
        narrative = self._generate_narrative(score, category, explanations, improvements)

        # Financial literacy tips based on category
        tips = self._get_financial_tips(category, explanations.get('negative', []))

        # Next steps
        next_steps = self._get_next_steps(category, improvements)

        return {
            'narrative': narrative,
            'tips': tips,
            'next_steps': next_steps,
            'score_context': self._get_score_context(score, category)
        }

    def generate_bank_recommendations(self, score: int, category: str,
                                       probability_of_default: float,
                                       explanations: Dict[str, List[str]],
                                       raw_features: Dict[str, float] = None) -> Dict[str, Any]:
        """
        Generate recommendations for bank officers.

        Args:
            score: Credit score
            category: Risk category
            probability_of_default: Default probability
            explanations: Risk factors
            raw_features: Raw extracted features

        Returns:
            Bank-focused recommendations
        """
        # Decision recommendation
        decision = self.BANK_DECISIONS.get(category, 'MANUAL_REVIEW')

        # Suggested credit limit (based on estimated income from features)
        estimated_monthly_income = raw_features.get('avg_balance', 5000) * 0.4 if raw_features else 5000
        base_limit = estimated_monthly_income * 12
        multiplier = self.CREDIT_LIMIT_MULTIPLIERS.get(category, 1.0)
        suggested_limit = int(base_limit * multiplier)

        # Interest rate tier
        rate_tier = self.INTEREST_RATE_TIERS.get(category, 'C')

        # Monitoring flags
        monitoring_flags = self._get_monitoring_flags(explanations, raw_features)

        # Conditions for approval
        conditions = self._get_approval_conditions(category, explanations, raw_features)

        return {
            'decision': decision,
            'suggested_limit': suggested_limit,
            'interest_rate_tier': rate_tier,
            'risk_level': self._get_risk_level(probability_of_default),
            'monitoring_flags': monitoring_flags,
            'conditions': conditions,
            'confidence': self._calculate_confidence(score, raw_features)
        }

    def _generate_narrative(self, score: int, category: str,
                            explanations: Dict[str, List[str]],
                            improvements: List[Dict[str, Any]]) -> str:
        """Generate plain-language narrative explanation."""
        # Try HuggingFace API if key is available
        if Config.HUGGINGFACE_API_KEY:
            narrative = self._generate_ai_narrative(score, category, explanations, improvements)
            if narrative:
                return narrative

        # Fallback to template-based narrative
        return self._generate_template_narrative(score, category, explanations, improvements)

    def _generate_ai_narrative(self, score: int, category: str,
                                explanations: Dict[str, List[str]],
                                improvements: List[Dict[str, Any]]) -> str:
        """Generate narrative using HuggingFace API."""
        try:
            prompt = f"""Given the following credit assessment:
- Credit Score: {score}
- Risk Category: {category}
- Positive Factors: {', '.join(explanations.get('positive', ['Good standing']))}
- Negative Factors: {', '.join(explanations.get('negative', ['None significant']))}
- Top Improvement: {improvements[0]['action'] if improvements else 'Maintain current habits'}

Generate a 2-3 sentence plain-language explanation suitable for a borrower with limited financial literacy. Be encouraging but honest."""

            headers = {
                'Authorization': f'Bearer {Config.HUGGINGFACE_API_KEY}',
                'Content-Type': 'application/json'
            }

            response = requests.post(
                f'https://api-inference.huggingface.co/models/{Config.HUGGINGFACE_MODEL}',
                headers=headers,
                json={'inputs': prompt, 'parameters': {'max_new_tokens': 150}},
                timeout=10
            )

            if response.status_code == 200:
                result = response.json()
                if isinstance(result, list) and len(result) > 0:
                    text = result[0].get('generated_text', '')
                    # Extract only the generated part (after the prompt)
                    if prompt in text:
                        text = text[len(prompt):].strip()
                    return text

        except Exception as e:
            print(f"AI narrative generation failed: {e}")

        return None

    def _generate_template_narrative(self, score: int, category: str,
                                      explanations: Dict[str, List[str]],
                                      improvements: List[Dict[str, Any]]) -> str:
        """Generate template-based narrative."""
        templates = {
            'Excellent': (
                f"Outstanding work! Your credit score of {score} places you in the top tier of financial health. "
                f"You've demonstrated exceptional reliability and credit management. "
                f"Lenders view you as a VIP – expect approval for premium cards and the lowest interest rates available."
            ),
            'Very Good': (
                f"Great job! Your score of {score} is well above average. "
                f"You are effectively managing your credit and are in a strong position. "
                f"You will qualify for most loans at competitive rates. "
                f"With just a bit more {improvements[0]['action'].lower() if improvements else 'consistency'}, you could reach the 'Excellent' tier."
            ),
            'Good': (
                f"You are on the right track! A score of {score} is solid and shows you are a responsible borrower. "
                f"Most lenders will see you as a safe bet. "
                f"To unlock the very best rates, focus on {improvements[0]['action'].lower() if improvements else 'lowering your utilization slightly'}."
            ),
            'Fair': (
                f"You have a foundation to build on. Your score of {score} means you can get credit, though it might come with higher rates. "
                f"The good news is that your score is dynamic. "
                f"Addressing {explanations.get('negative', ['recent payment gaps'])[0].lower()} is your quickest path to a better score."
            ),
            'Poor': (
                f"Your score of {score} suggests currently high financial stress, but this is temporary if you take action. "
                f"The most impactful change you can make right now is: {improvements[0]['action'] if improvements else 'avoiding any new missed payments'}. "
                f"Small, consistent steps will start rebuilding your score immediately."
            )
        }

        return templates.get(category, templates['Fair'])

    def _get_financial_tips(self, category: str, negative_factors: List[str]) -> List[str]:
        """Get financial literacy tips based on situation."""
        tips = []

        # Category-based tips
        if category in ['Poor', 'Fair']:
            tips.append("Set up automatic payments to avoid missing due dates")
            tips.append("Check your credit report annually for errors at annualcreditreport.com")

        if category == 'Poor':
            tips.append("Consider a secured credit card to rebuild credit")
            tips.append("Keep credit utilization below 30% of your limit")

        # Factor-based tips
        for factor in negative_factors:
            if 'payment' in factor.lower() or 'late' in factor.lower():
                tips.append("Payment history is the biggest factor - prioritize on-time payments")
            if 'utilization' in factor.lower() or 'balance' in factor.lower():
                tips.append("High balances hurt your score - try to pay down debt")
            if 'overdraft' in factor.lower():
                tips.append("Maintain an emergency fund to avoid overdrafts")

        # General tips
        tips.append("Avoid opening too many new accounts in a short period")

        return list(set(tips))[:5]  # Return up to 5 unique tips

    def _get_next_steps(self, category: str, improvements: List[Dict[str, Any]]) -> List[str]:
        """Get actionable next steps."""
        steps = []

        # Add top improvements as steps
        for imp in improvements[:3]:
            steps.append(f"{imp['action']} ({imp.get('timeline', 'ongoing')})")

        # Category-specific steps
        if category == 'Excellent':
            steps.append("Leverage your score for premium rewards cards")
            steps.append("Negotiate lower rates on existing loans")
        elif category == 'Very Good':
            steps.append("Consider requesting a credit limit increase")
            steps.append("Avoid new hard inquiries to protect your score")
        elif category == 'Good':
            steps.append("Review your credit report for any errors")
            steps.append("Maintain current good habits to reach the next tier")
        elif category == 'Fair':
            steps.append("Create a debt paydown plan")
            steps.append("Consider credit counseling if needed")
        elif category == 'Poor':
            steps.append("Consult with a nonprofit credit counselor")
            steps.append("Focus on building emergency savings")

        return steps[:5]

    def _get_score_context(self, score: int, category: str) -> Dict[str, Any]:
        """Provide context for the score."""
        return {
            'national_average': 711,
            'your_percentile': self._estimate_percentile(score),
            'category_range': Config.RISK_CATEGORIES.get(category, (300, 850)),
            'points_to_next_category': self._points_to_next_category(score, category)
        }

    def _estimate_percentile(self, score: int) -> int:
        """Estimate percentile rank for score."""
        # Simplified percentile estimation
        if score >= 800:
            return 95
        elif score >= 750:
            return 85
        elif score >= 700:
            return 65
        elif score >= 650:
            return 45
        elif score >= 600:
            return 25
        elif score >= 550:
            return 15
        else:
            return 5

    def _points_to_next_category(self, score: int, category: str) -> int:
        """Calculate points needed for next category."""
        category_mins = {'Excellent': 800, 'Very Good': 740, 'Good': 670, 'Fair': 580, 'Poor': 300}
        order = ['Poor', 'Fair', 'Good', 'Very Good', 'Excellent']

        current_idx = order.index(category) if category in order else 0
        if current_idx >= len(order) - 1:
            return 0  # Already in top category

        next_category = order[current_idx + 1]
        next_min = category_mins[next_category]

        return max(0, next_min - score)

    def _get_monitoring_flags(self, explanations: Dict[str, List[str]],
                               raw_features: Dict[str, float]) -> List[str]:
        """Identify areas that need monitoring."""
        flags = []

        for factor in explanations.get('negative', []):
            if 'payment' in factor.lower() or 'late' in factor.lower():
                flags.append('payment_history')
            if 'utilization' in factor.lower() or 'balance' in factor.lower():
                flags.append('utilization')
            if 'volatility' in factor.lower() or 'inconsistent' in factor.lower():
                flags.append('spending_volatility')
            if 'overdraft' in factor.lower():
                flags.append('overdraft_risk')
            if 'income' in factor.lower():
                flags.append('income_stability')

        return list(set(flags))

    def _get_approval_conditions(self, category: str,
                                  explanations: Dict[str, List[str]],
                                  raw_features: Dict[str, float]) -> List[str]:
        """Get conditions for credit approval."""
        conditions = []

        if category == 'Fair':
            conditions.append("Require income verification")
            conditions.append("Consider lower initial limit with increase option")
        elif category == 'Poor':
            conditions.append("Require secured deposit or co-signer")
            conditions.append("Mandatory financial counseling")
            conditions.append("Monthly account review for first 6 months")

        # Feature-based conditions
        if raw_features:
            if raw_features.get('overdraft_frequency', 0) > 0.1:
                conditions.append("Set up overdraft protection")
            if raw_features.get('income_stability', 0) > 0.6:
                conditions.append("Provide 3 months of pay stubs")

        return conditions

    def _get_risk_level(self, probability: float) -> str:
        """Convert probability to risk level."""
        if probability < 0.1:
            return 'LOW'
        elif probability < 0.25:
            return 'MEDIUM'
        elif probability < 0.5:
            return 'HIGH'
        else:
            return 'VERY_HIGH'

    def _calculate_confidence(self, score: int, raw_features: Dict[str, float]) -> str:
        """Calculate confidence level of assessment."""
        if not raw_features:
            return 'LOW'

        # Factors influencing confidence
        txn_count = raw_features.get('transaction_count', 0)
        account_age = raw_features.get('account_age', 0)
        volatility = raw_features.get('transaction_volatility', 0)

        # 1. Data Sufficiency
        if txn_count < 5:
            return 'LOW'  # Not enough data points
        
        if txn_count < 20 and account_age < 90:
            return 'MEDIUM'

        # 2. Pattern Stability
        if volatility > 1.5:
             # Even with data, behavior is too erratic to be confident
             return 'MEDIUM' 

        return 'HIGH'


# Singleton instance
_engine = None


def get_recommendation_engine() -> RecommendationEngine:
    """Get or create the singleton recommendation engine instance."""
    global _engine
    if _engine is None:
        _engine = RecommendationEngine()
    return _engine
