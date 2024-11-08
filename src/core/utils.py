# utils.py

import logging
import asyncio
from sqlalchemy import create_engine
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
from aiohttp import web
import jwt
from config import Config

logger = logging.getLogger(__name__)

async def initialize_database(db_uri):
    """Initialize the asynchronous database connection."""
    try:
        engine = create_async_engine(db_uri, echo=True)
        async_session = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)
        logger.info("Database connection established.")
        return async_session
    except Exception as e:
        logger.error(f"Failed to connect to the database: {e}")
        raise

def setup_routes(app, db_session):
    """Set up the application routes."""
    app.router.add_get('/', home)
    app.router.add_post('/api/v1/users', create_user)
    app.router.add_post('/api/v1/login', login_user)
    # Add more routes as needed

async def home(request):
    """Home route."""
    return web.Response(text="Welcome to the DAFE Ecosystem!")

async def create_user(request):
    """Create a new user."""
    try:
        data = await request.json()
        # Validate input data
        validate_user_data(data)
        # Logic to create user in the database
        return web.json_response({"message": "User  created successfully."}, status=201)
    except ValueError as ve:
        return web.json_response({"error": str(ve)}, status=400)
    except Exception as e:
        logger.error(f"Error creating user: {e}")
        return web.json_response({"error": "Internal Server Error"}, status=500)

async def login_user(request):
    """Login a user and return a JWT token."""
    try:
        data = await request.json()
        validate_login_data(data)
        # Logic to authenticate user and generate JWT
        token = generate_jwt(data['username'])
        return web.json_response({"token": token}, status=200)
    except ValueError as ve:
        return web.json_response({"error": str(ve)}, status=400)
    except Exception as e:
        logger.error(f"Error logging in user: {e}")
        return web.json_response({"error": "Internal Server Error"}, status=500)

def validate_user_data(data):
    """Validate user data for creation."""
    if 'username' not in data or 'password' not in data:
        raise ValueError("Username and password are required.")

def validate_login_data(data):
    """Validate login data."""
    if 'username' not in data or 'password' not in data:
        raise ValueError("Username and password are required.")

def generate_jwt(username):
    """Generate a JWT token for the user."""
    payload = {
        'sub': username,
        'iat': int(asyncio.get_event_loop().time()),  # Issued at
        'exp': int(asyncio.get_event_loop().time()) + 3600  # Expires in 1 hour
    }
    token = jwt.encode(payload, Config.JWT_SECRET, algorithm='HS256')
    return token

def log_request(request):
    """Log incoming requests."""
    logger.info(f"Request: {request.method} {request.path}")

def log_response(response):
    """Log outgoing responses."""
    logger.info(f"Response: {response.status} {response.text}")

# Example of a utility function for error handling
def handle_error(error):
    """Handle errors and log them."""
    logger.error(f"An error occurred: {error}")
    return {"error": str(error)}
