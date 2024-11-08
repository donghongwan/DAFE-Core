# routes.py

from flask import Blueprint, request, jsonify
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from web3 import Web3
import json
from models import User
from database.db import db

api_routes = Blueprint('api', __name__)

# Connect to Ethereum network
w3 = Web3(Web3.HTTPProvider('http://127.0.0.1:8545'))

# Load contract ABI and address (replace with actual ABI and address)
erc20_abi = json.loads('[...]')  # Replace with actual ERC20 ABI
erc20_address = '0xYourERC20Address'  # Replace with actual ERC20 contract address
erc20_contract = w3.eth.contract(address=erc20_address, abi=erc20_abi)

@api_routes.route('/register', methods=['POST'])
def register():
    data = request.json
    new_user = User(address=data['address'])
    db.session.add(new_user)
    db.session.commit()
    return jsonify({'message': 'User  registered successfully'}), 201

@api_routes.route('/login', methods=['POST'])
def login():
    data = request.json
    user = User.query.filter_by(address=data['address']).first()
    if user:
        access_token = create_access_token(identity=user.address)
        return jsonify(access_token=access_token), 200
    return jsonify({'message': 'User  not found'}), 404

@api_routes.route('/balance', methods=['GET'])
@jwt_required()
def get_balance():
    current_user = get_jwt_identity()
    balance = erc20_contract.functions.balanceOf(current_user).call()
    return jsonify({'balance': balance})

# Additional routes for staking, proposing, etc. with @jwt_required() decorator
 ```python
@api_routes.route('/stake', methods=['POST'])
@jwt_required()
def stake_tokens():
    current_user = get_jwt_identity()
    data = request.json
    amount = data.get('amount')
    private_key = data.get('private_key')

    # Create transaction for staking
    nonce = w3.eth.getTransactionCount(current_user)
    tx = staking_contract.functions.stake(amount).buildTransaction({
        'chainId': 1,
        'gas': 2000000,
        'gasPrice': w3.toWei('50', 'gwei'),
        'nonce': nonce,
    })

    # Sign the transaction
    signed_tx = w3.eth.account.signTransaction(tx, private_key)
    tx_hash = w3.eth.sendRawTransaction(signed_tx.rawTransaction)

    return jsonify({'transaction_hash': tx_hash.hex()})

@api_routes.route('/propose', methods=['POST'])
@jwt_required()
def propose():
    current_user = get_jwt_identity()
    data = request.json
    recipient = data.get('recipient')
    amount = data.get('amount')
    description = data.get('description')
    private_key = data.get('private_key')

    # Create transaction for proposal
    nonce = w3.eth.getTransactionCount(current_user)
    tx = governance_contract.functions.createProposal(recipient, amount, description).buildTransaction({
        'chainId': 1,
        'gas': 2000000,
        'gasPrice': w3.toWei('50', 'gwei'),
        'nonce': nonce,
    })

    # Sign the transaction
    signed_tx = w3.eth.account.signTransaction(tx, private_key)
    tx_hash = w3.eth.sendRawTransaction(signed_tx.rawTransaction)

    return jsonify({'transaction_hash': tx_hash.hex()})

@api_routes.route('/claim_reward', methods=['POST'])
@jwt_required()
def claim_reward():
    current_user = get_jwt_identity()
    private_key = request.json.get('private_key')

    # Create transaction for claiming reward
    nonce = w3.eth.getTransactionCount(current_user)
    tx = staking_contract.functions.claimReward().buildTransaction({
        'chainId': 1,
        'gas': 2000000,
        'gasPrice': w3.toWei('50', 'gwei'),
        'nonce': nonce,
    })

    # Sign the transaction
    signed_tx = w3.eth.account.signTransaction(tx, private_key)
    tx_hash = w3.eth.sendRawTransaction(signed_tx.rawTransaction)

    return jsonify({'transaction_hash': tx_hash.hex()})
