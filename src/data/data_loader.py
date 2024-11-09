# data/data_loader.py

import pandas as pd
import os
import json
import logging
from concurrent.futures import ThreadPoolExecutor, as_completed
from sqlalchemy import create_engine
from sqlalchemy.exc import SQLAlchemyError

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class DataLoader:
    def __init__(self, db_url=None):
        self.db_url = db_url
        if db_url:
            self.engine = create_engine(db_url)

    def load_user_data(self):
        """Load user data from the database."""
        if not self.db_url:
            logger.error("Database URL not provided.")
            return None

        try:
            query = "SELECT address, balance FROM users"
            user_data = pd.read_sql(query, self.engine)
            logger.info("User  data loaded successfully.")
            return user_data
        except SQLAlchemyError as e:
            logger.error(f"Error loading user data: {e}")
            return None

    def load_data_from_csv(self, file_path):
        """Load data from a CSV file."""
        if not os.path.exists(file_path):
            logger.error(f"CSV file not found: {file_path}")
            return None

        try:
            data = pd.read_csv(file_path)
            logger.info(f"Data loaded from CSV: {file_path}")
            return data
        except Exception as e:
            logger.error(f"Error loading data from CSV: {e}")
            return None

    def load_data_from_json(self, file_path):
        """Load data from a JSON file."""
        if not os.path.exists(file_path):
            logger.error(f"JSON file not found: {file_path}")
            return None

        try:
            with open(file_path, 'r') as f:
                data = json.load(f)
            logger.info(f"Data loaded from JSON: {file_path}")
            return pd.DataFrame(data)
        except Exception as e:
            logger.error(f"Error loading data from JSON: {e}")
            return None

    def load_data_from_api(self, api_url):
        """Load data from an API."""
        try:
            data = pd.read_json(api_url)
            logger.info(f"Data loaded from API: {api_url}")
            return data
        except Exception as e:
            logger.error(f"Error loading data from API: {e}")
            return None

    def load_data_in_parallel(self, sources):
        """Load data from multiple sources in parallel."""
        results = {}
        with ThreadPoolExecutor() as executor:
            future_to_source = {executor.submit(self.load_data, source): source for source in sources}
            for future in as_completed(future_to_source):
                source = future_to_source[future]
                try:
                    data = future.result()
                    results[source] = data
                except Exception as e:
                    logger.error(f"Error loading data from {source}: {e}")
                    results[source] = None
        return results

    def load_data(self, source):
        """Load data based on the source type."""
        if source['type'] == 'csv':
            return self.load_data_from_csv(source['path'])
        elif source['type'] == 'json':
            return self.load_data_from_json(source['path'])
        elif source['type'] == 'api':
            return self.load_data_from_api(source['url'])
        elif source['type'] == 'database':
            return self.load_user_data()
        else:
            logger.error(f"Unsupported data source type: {source['type']}")
            return None

    def cache_data(self, data, cache_file):
        """Cache data to a CSV file for faster access."""
        try:
            data.to_csv(cache_file, index=False)
            logger.info(f"Data cached to {cache_file}")
        except Exception as e:
            logger.error(f"Error caching data: {e}")

    def load_cached_data(self, cache_file):
        """Load data from a cached CSV file."""
        if os.path.exists(cache_file):
            try:
                data = pd.read_csv(cache_file)
                logger.info(f"Data loaded from cache: {cache_file}")
                return data
            except Exception as e:
                logger.error(f"Error loading cached data: {e}")
                return None
        else:
            logger.warning(f"Cache file not found: {cache_file}")
            return None
