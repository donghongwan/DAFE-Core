# utils.py

def validate_address(address):
    # Logic to validate Ethereum address
    return Web3.isChecksumAddress(address)

def handle_error(error):
    # Centralized error handling logic
    return jsonify({'error': str(error)}), 500
