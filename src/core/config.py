# config.py

import os
import json
import logging
from dotenv import load_dotenv

# Load environment variables from a .env file
load_dotenv()

class Config:
    """Configuration settings for the DAFE application."""
    
    # Environment settings
    ENVIRONMENT = os.getenv("ENVIRONMENT", "development").lower()
    
    # Database settings
    DB_URI = os.getenv("DB_URI", "sqlite:///dafe.db")  # Default to SQLite for local development
    DB_POOL_SIZE = int(os.getenv("DB_POOL_SIZE", 5))  # Connection pool size

    # Server settings
    SERVER_HOST = os.getenv("SERVER_HOST", "0.0.0.0")
    SERVER_PORT = int(os.getenv("SERVER_PORT", 5000))
    
    # Logging settings
    LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO").upper()
    
    # API settings
    API_RATE_LIMIT = int(os.getenv("API_RATE_LIMIT", 100))  # Requests per minute
    API_TIMEOUT = int(os.getenv("API_TIMEOUT", 30))  # Timeout in seconds

    # Security settings
    SECRET_KEY = os.getenv("SECRET_KEY", "your_default_secret_key")  # Change this in production
    JWT_SECRET = os.getenv("JWT_SECRET", "your_jwt_secret")  # JWT secret for authentication

    # Feature flags
    ENABLE_FEATURE_X = os.getenv("ENABLE_FEATURE_X", "false").lower() == "true"

    def __init__(self):
        self.validate()

    def validate(self):
        """Validate configuration settings."""
        if not self.DB_URI:
            raise ValueError("Database URI must be set.")
        if not self.SERVER_PORT:
            raise ValueError("Server port must be a valid integer.")
        if self.ENVIRONMENT not in ["development", "testing", "production"]:
            raise ValueError("Environment must be one of: development, testing, production.")
        if not self.SECRET_KEY or self.SECRET_KEY == "your_default_secret_key":
            raise ValueError("A secure SECRET_KEY must be set for production.")

    def to_dict(self):
        """Convert configuration to a dictionary."""
        return {
            "environment": self.ENVIRONMENT,
            "db_uri": self.DB_URI,
            "db_pool_size": self.DB_POOL_SIZE,
            "server_host": self.SERVER_HOST,
            "server_port": self.SERVER_PORT,
            "log_level": self.LOG_LEVEL,
            "api_rate_limit": self.API_RATE_LIMIT,
            "api_timeout": self.API_TIMEOUT,
            "secret_key": self.SECRET_KEY,
            "jwt_secret": self.JWT_SECRET,
            "enable_feature_x": self.ENABLE_FEATURE_X,
        }

# Logging configuration
logging.basicConfig(level=Config.LOG_LEVEL)
logger = logging.getLogger(__name__)
logger.info(f"Configuration loaded: {Config().to_dict()}")
