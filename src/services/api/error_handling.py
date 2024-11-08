# error_handling.py

from flask import jsonify

def handle_api_error(error):
    response = jsonify({'message': str(error)})
    response.status_code = 400
    return response
