# tests/test_core.py

import unittest
import pandas as pd
from data.data_loader import DataLoader
from data.data_processor import DataProcessor

class TestCore(unittest.TestCase):
    def setUp(self):
        self.data_loader = DataLoader()
        self.data_processor = DataProcessor()
        self.test_data = pd.DataFrame({
            'address': ['addr1', 'addr2', 'addr3'],
            'balance': [100.0, 200.0, None]
        })

    def test_clean_data(self):
        cleaned_data = self.data_processor.clean_data(self.test_data)
        self.assertEqual(cleaned_data.shape[0], 2)  # Should remove one row with NaN

    def test_validate_data(self):
        expected_columns = ['address', 'balance']
        is_valid = self.data_processor.validate_data(self.test_data, expected_columns)
        self.assertTrue(is_valid)

    def test_transform_data(self):
        transformed_data = self.data_processor.transform_data(self.test_data, scale=False)
        self.assertIn('balance', transformed_data.columns)

    def test_feature_engineering(self):
        engineered_data = self.data_processor.feature_engineering(self.test_data)
        self.assertIn('balance_squared', engineered_data.columns)
        self.assertIn('log_balance', engineered_data.columns)

if __name__ == '__main__':
    unittest.main()
