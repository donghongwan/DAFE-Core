# auth.py

from flask_jwt_extended import jwt_required, get_jwt_identity
from functools import wraps
from flask import jsonify

def admin_required(fn):
    @wraps(fn)
    @jwt_required()
    def wrapper(*args, **kwargs):
        current_user = get_jwt_identity()
        # Check if the user has admin privileges
        if not is_admin(current_user):
            return jsonify({'message': 'Admin access required'}), 403
        return fn(*args, **kwargs)
    return wrapper

def is_admin(user_address):
    # Logic to check if the user is an admin
    return user_address in ['0xAdminAddress1', '0xAdminAddress2']  # Replace with actual admin addresses
