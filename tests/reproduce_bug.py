
import unittest
import sys
import os

# Add backend to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../backend')))

from ml.feature_extractor import FeatureExtractor
from ml.predictor import get_predictor

class TestBugReproduction(unittest.TestCase):
    def setUp(self):
        self.extractor = FeatureExtractor()
        self.predictor = get_predictor()

    def test_risky_overdrafter_gets_bad_score(self):
        """
        Scenario: User pays on time (consistent) but has frequent overdrafts and high spending.
        Current Bug: Gets 850 Score because PAY_0 is -1 (On Time).
        Fix Expectation: Score should be penalized significantly (< 700).
        """
        transactions = []
        # Generate 60 days of transactions
        # Pays consistently every 15 days
        for i in range(4):
            transactions.append({
                'date': f'2024-01-{1 + i*15:02d}', 
                'amount': 2000, 
                'type': 'credit', 
                'balance': 100 
            })
        
        # Consistent payments = Good Payment Score
        
        # But... frequent overdrafts
        for i in range(10):
             transactions.append({
                'date': f'2024-01-{2 + i*2:02d}', 
                'amount': 50, 
                'type': 'debit', 
                'balance': -50 # Overdraft!
            })
             
        features = self.extractor.extract_features(transactions)
        prediction = self.predictor.predict(features.copy())
        
        print(f"Risky User Score: {prediction['score']}")
        print(f"Risk Category: {prediction['category']}")
        print(f"Overdraft Freq: {features['_raw_features']['overdraft_frequency']}")
        
        # This assertion will fail if the bug exists (Score 850)
        self.assertLess(prediction['score'], 700, "Risky overdrafter should not have excellent credit")

if __name__ == '__main__':
    unittest.main()
