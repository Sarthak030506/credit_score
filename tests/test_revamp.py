
import unittest
import logging
import sys
import os

# Add backend to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../backend')))

from ml.feature_extractor import FeatureExtractor
from ml.predictor import get_predictor
from utils.recommendations import get_recommendation_engine

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class TestRevamp(unittest.TestCase):
    def setUp(self):
        self.extractor = FeatureExtractor()
        self.predictor = get_predictor()
        self.recommender = get_recommendation_engine()

    def test_risky_borrower_penalties(self):
        """
        Scenario: 'Risky Borrower' from bug report.
        - Consistent payments (was fooling the old model).
        - Frequent overdrafts.
        - High volatility.
        Expectation: Score < 700 (Fair/Poor), Confidence MEDIUM/LOW.
        """
        transactions = []
        # Consistent payments
        for i in range(4):
            transactions.append({'date': f'2024-01-{1 + i*15:02d}', 'amount': 2000, 'type': 'credit', 'balance': 500})
        
        # Overdrafts (10 txns)
        for i in range(10):
             transactions.append({'date': f'2024-01-{2 + i*2:02d}', 'amount': 50, 'type': 'debit', 'balance': -50})
             
        features = self.extractor.extract_features(transactions)
        prediction = self.predictor.predict(features.copy())
        
        score = prediction['score']
        category = prediction['category']
        raw_features = prediction['raw_features']
        
        logger.info(f"Revamp Risky Score: {score} ({category})")
        logger.info(f"Overdraft Freq: {raw_features.get('overdraft_frequency')}")
        
        # Verify Score Cap
        self.assertLess(score, 740, "Should be penalized below Excellent")
        self.assertLess(score, 700, "Should be penalized to Fair/Poor due to high overdraft freq")
        
        # Verify Confidence
        # Count > 5, but Volatility likely high
        confidence = self.recommender._calculate_confidence(score, raw_features)
        logger.info(f"Confidence: {confidence}")
        
        # Volatility check
        volatility = raw_features.get('transaction_volatility', 0)
        logger.info(f"Volatility: {volatility}")
        
        if volatility > 1.5:
            self.assertEqual(confidence, 'MEDIUM', "High volatility should lower confidence")

    def test_thin_file_confidence(self):
        """
        Scenario: User with very few transactions.
        Expectation: Low Confidence.
        """
        transactions = [
            {'date': '2024-01-01', 'amount': 1000, 'type': 'credit', 'balance': 1000},
            {'date': '2024-01-02', 'amount': 50, 'type': 'debit', 'balance': 950}
        ]
        
        features = self.extractor.extract_features(transactions)
        prediction = self.predictor.predict(features.copy())
        
        raw_features = prediction['raw_features']
        confidence = self.recommender._calculate_confidence(prediction['score'], raw_features)
        
        logger.info(f"ci Thin File Confidence: {confidence}")
        self.assertEqual(confidence, 'LOW', "Few transactions should result in Low confidence")

if __name__ == '__main__':
    unittest.main()
