
import unittest
import pandas as pd
from backend.ml.feature_extractor import FeatureExtractor

class TestFeatureExtractor(unittest.TestCase):
    def setUp(self):
        self.extractor = FeatureExtractor()

    def test_irregular_but_good_payments(self):
        """Test that irregular payments (e.g. freelance style) are not marked as late."""
        # User pays on 1st, 5th, 10th - very irregular dates, but frequent
        transactions = [
            {'date': '2024-01-01', 'amount': 1000, 'type': 'credit', 'balance': 5000},
            {'date': '2024-01-05', 'amount': 2000, 'type': 'credit', 'balance': 7000},
            {'date': '2024-01-15', 'amount': 1500, 'type': 'credit', 'balance': 8500},
            {'date': '2024-02-02', 'amount': 3000, 'type': 'credit', 'balance': 11500}, # Gap of ~18 days
        ]
        
        features = self.extractor.extract_features(transactions)
        
        # In old logic, std(days) would be high -> Bad score
        # In new logic, max(days) is roughly 18 -> Good score
        
        print(f"Payment Consistency (Max Gap): {features['_raw_features']['payment_consistency']}")
        print(f"Mapped PAY_0: {features['PAY_0']}")
        
        self.assertLess(features['_raw_features']['payment_consistency'], 35, "Max gap should be < 35 days")
        self.assertEqual(features['PAY_0'], -1, "Should be mapped to 'Paid on time' (-1)")

    def test_missed_month(self):
        """Test that missing a whole month is correctly marked as late."""
        transactions = [
            {'date': '2024-01-01', 'amount': 1000, 'type': 'credit', 'balance': 5000},
            # Missing Feb
            {'date': '2024-03-01', 'amount': 1000, 'type': 'credit', 'balance': 6000},
        ]
        
        features = self.extractor.extract_features(transactions)
        
        print(f"Payment Consistency (Max Gap): {features['_raw_features']['payment_consistency']}")
        print(f"Mapped PAY_0: {features['PAY_0']}")
        
        self.assertGreater(features['_raw_features']['payment_consistency'], 58, "Max gap should be > 58 days")
        self.assertGreaterEqual(features['PAY_0'], 1, "Should be marked as late")

if __name__ == '__main__':
    unittest.main()
