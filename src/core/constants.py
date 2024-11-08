# constants.py

# API Response Messages
class ApiResponseMessages:
    USER_CREATED = "User  created successfully."
    USER_ALREADY_EXISTS = "User  already exists."
    USER_NOT_FOUND = "User  not found."
    INVALID_CREDENTIALS = "Invalid username or password."
    INTERNAL_SERVER_ERROR = "Internal Server Error."
    UNAUTHORIZED_ACCESS = "Unauthorized access."
    TOKEN_EXPIRED = "Token has expired."
    TOKEN_INVALID = "Token is invalid."

# HTTP Status Codes
class HttpStatusCodes:
    OK = 200
    CREATED = 201
    BAD_REQUEST = 400
    UNAUTHORIZED = 401
    FORBIDDEN = 403
    NOT_FOUND = 404
    INTERNAL_SERVER_ERROR = 500

# Feature Flags
class FeatureFlags:
    ENABLE_USER_VERIFICATION = True  # Enable user email verification
    ENABLE_TWO_FACTOR_AUTH = False  # Enable two-factor authentication
    ENABLE_API_RATE_LIMITING = True  # Enable rate limiting for APIs
    ENABLE_LOGGING = True  # Enable detailed logging

# Database Constants
class DatabaseConstants:
    USER_TABLE = "users"
    TRANSACTION_TABLE = "transactions"
    ASSET_TABLE = "assets"

# JWT Constants
class JwtConstants:
    ALGORITHM = "HS256"
    EXPIRATION_TIME = 3600  # Token expiration time in seconds

# Miscellaneous Constants
class MiscConstants:
    APP_NAME = "Decentralized Autonomous Finance Ecosystem (DAFE)"
    VERSION = "1.0.0"
    DEFAULT_PAGE_SIZE = 10  # Default number of items per page for pagination
    MAX_PAGE_SIZE = 100  # Maximum number of items per page for pagination

# Logging Constants
class LoggingConstants:
    LOG_FORMAT = "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    LOG_FILE = "dafe.log"  # Log file name
    LOG_LEVEL = "INFO"  # Default log level

# Security Constants
class SecurityConstants:
    PASSWORD_HASH_SALT = "your_salt_here"  # Salt for password hashing
    PASSWORD_HASH_ITERATIONS = 100000  # Number of iterations for hashing

# Example of how to use constants in the application
def print_constants():
    print(f"App Name: {MiscConstants.APP_NAME}, Version: {MiscConstants.VERSION}")
    print(f"JWT Algorithm: {JwtConstants.ALGORITHM}, Expiration Time: {JwtConstants.EXPIRATION_TIME} seconds")

# Uncomment to print constants
# print_constants()
