
import unittest
import json
import logging
import sys
import os

# Add backend to sys.path to resolve 'config' module imports
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../backend')))

from ml.feature_extractor import FeatureExtractor
from ml.predictor import get_predictor
from utils.recommendations import get_recommendation_engine
from ml.explainer import get_explainer

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class TestFullSystem(unittest.TestCase):
    def setUp(self):
        self.extractor = FeatureExtractor()
        self.predictor = get_predictor()
        self.recommender = get_recommendation_engine()
        self.explainer = get_explainer()

    def test_freelancer_good_profile(self):
        """
        Scenario: Freelancer with irregular payment dates but always pays in full.
        Expectation: Good Score, Positive Trend, Reward Eligible.
        """
        transactions = [
            {'date': '2024-01-02', 'amount': 2000, 'type': 'credit', 'balance': 5000},
            {'date': '2024-01-05', 'amount': 1000, 'type': 'debit', 'balance': 4000},
            {'date': '2024-01-20', 'amount': 3000, 'type': 'credit', 'balance': 7000}, # Gap ~18 days
            {'date': '2024-02-10', 'amount': 2500, 'type': 'credit', 'balance': 9500}, # Gap ~21 days
        ]
        
        features = self.extractor.extract_features(transactions)
        prediction = self.predictor.predict(features.copy())
        
        # Verify Score Logic
        logger.info(f"Freelancer Score: {prediction['score']} ({prediction['category']})")
        self.assertGreaterEqual(prediction['score'], 670, "Freelancer should have Good+ score")
        self.assertIn(prediction['category'], ['Good', 'Excellent'])
        
        # Verify Recommendation Signals
        raw_features = prediction.get('raw_features', {})
        trend = 'stable'
        if raw_features.get('payment_consistency', 30) < 20:
             trend = 'improving'
        
        reward_eligible = prediction['category'] in ['Excellent', 'Good'] and trend != 'declining'
        
        self.assertTrue(reward_eligible, "Freelancer should be eligible for rewards")
        logger.info(f"Freelancer Trend: {trend}, Reward Eligible: {reward_eligible}")

    def test_missing_payments_poor_profile(self):
        """
        Scenario: User missing months of payments.
        Expectation: Poor/Fair Score, Declining Trend.
        """
        transactions = [
            {'date': '2024-01-01', 'amount': 1000, 'type': 'credit', 'balance': 1000},
            {'date': '2024-03-15', 'amount': 1000, 'type': 'credit', 'balance': 500}, # Gap > 70 days
        ]
        
        features = self.extractor.extract_features(transactions)
        prediction = self.predictor.predict(features.copy())
        
        logger.info(f"Poor Profile Score: {prediction['score']} ({prediction['category']})")
        self.assertLess(prediction['score'], 670, "Should be Fair or Poor")
        
        raw_features = prediction.get('raw_features', {})
        trend = 'stable'
        if raw_features.get('payment_consistency', 30) > 40:
             trend = 'declining'
        
        self.assertEqual(trend, 'declining', "Trend should be declining")

if __name__ == '__main__':
    unittest.main()
