# data/data_processor.py

import pandas as pd
import numpy as np
import logging
from sklearn.preprocessing import StandardScaler, MinMaxScaler
from sklearn.impute import SimpleImputer
from concurrent.futures import ThreadPoolExecutor, as_completed

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class DataProcessor:
    def __init__(self):
        self.imputer = SimpleImputer(strategy='mean')
        self.scaler = None

    def clean_data(self, data):
        """Clean the data by removing null values and duplicates."""
        logger.info("Starting data cleaning process.")
        initial_shape = data.shape
        data = data.dropna()
        data = data.drop_duplicates()
        logger.info(f"Cleaned data from {initial_shape} to {data.shape}.")
        return data

    def validate_data(self, data, expected_columns):
        """Validate the data against expected columns."""
        missing_columns = set(expected_columns) - set(data.columns)
        if missing_columns:
            logger.error(f"Missing columns in data: {missing_columns}")
            return False
        logger.info("Data validation passed.")
        return True

    def transform_data(self, data, scale=False):
        """Transform data by applying necessary calculations and scaling."""
        logger.info("Starting data transformation process.")
        data['balance'] = data['balance'].apply(lambda x: round(x, 2))  # Example transformation

        if scale:
            self.scaler = StandardScaler()
            data[['balance']] = self.scaler.fit_transform(data[['balance']])
            logger.info("Data scaling applied.")

        return data

    def aggregate_data(self, data, group_by_column):
        """Aggregate data by a specified column."""
        logger.info(f"Aggregating data by {group_by_column}.")
        aggregated_data = data.groupby(group_by_column).sum().reset_index()
        logger.info(f"Aggregated data shape: {aggregated_data.shape}.")
        return aggregated_data

    def feature_engineering(self, data):
        """Create new features based on existing data."""
        logger.info("Starting feature engineering.")
        data['balance_squared'] = data['balance'] ** 2
        data['log_balance'] = np.log1p(data['balance'])  # log(1 + balance) to avoid log(0)
        logger.info("Feature engineering completed.")
        return data

    def process_data_in_parallel(self, data, operations):
        """Process data using specified operations in parallel."""
        results = {}
        with ThreadPoolExecutor() as executor:
            future_to_operation = {executor.submit(self.apply_operation, data, op): op for op in operations}
            for future in as_completed(future_to_operation):
                operation = future_to_operation[future]
                try:
                    result = future.result()
                    results[operation] = result
                except Exception as e:
                    logger.error(f"Error processing operation {operation}: {e}")
                    results[operation] = None
        return results

    def apply_operation(self, data, operation):
        """Apply a specific operation to the data."""
        if operation == 'clean':
            return self.clean_data(data)
        elif operation == 'transform':
            return self.transform_data(data)
        elif operation == 'feature_engineering':
            return self.feature_engineering(data)
        elif operation == 'aggregate':
            return self.aggregate_data(data, 'address')  # Example aggregation
        else:
            logger.error(f"Unsupported operation: {operation}")
            return None
