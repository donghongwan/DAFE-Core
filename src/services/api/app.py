# app.py

from flask import Flask
from flask_jwt_extended import JWTManager
from flask_cors import CORS
from flask_limiter import Limiter
from routes import api_routes
from database.db import db
import os

app = Flask(__name__)
CORS(app)

# Load configuration from environment variables
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL', 'sqlite:///site.db')
app.config['JWT_SECRET_KEY'] = os.getenv('JWT_SECRET_KEY', 'your_jwt_secret_key')
app.config['CELERY_BROKER_URL'] = os.getenv('CELERY_BROKER_URL', 'redis://localhost:6379/0')
app.config['CELERY_RESULT_BACKEND'] = os.getenv('CELERY_RESULT_BACKEND', 'redis://localhost:6379/0')

# Initialize extensions
db.init_app(app)
jwt = JWTManager(app)
limiter = Limiter(app, key_func=get_remote_address)

# Register the API routes
app.register_blueprint(api_routes)

@app.route('/')
def home():
    return "Welcome to the Blockchain API!"

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
