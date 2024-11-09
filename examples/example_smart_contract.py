# example_smart_contract.py

from web3 import Web3
import json
import os

# Load environment variables
INFURA_URL = os.getenv('INFURA_URL')  # Infura URL for Ethereum node
PRIVATE_KEY = os.getenv('PRIVATE_KEY')  # Private key for signing transactions
ACCOUNT_ADDRESS = os.getenv('ACCOUNT_ADDRESS')  # Your Ethereum account address
CONTRACT_ADDRESS = os.getenv('CONTRACT_ADDRESS')  # Deployed contract address

# Load contract ABI
with open('contract_abi.json') as f:
    contract_abi = json.load(f)

# Connect to Ethereum node
web3 = Web3(Web3.HTTPProvider(INFURA_URL))

# Check if connected
if not web3.isConnected():
    raise Exception("Failed to connect to Ethereum node")

# Create contract instance
contract = web3.eth.contract(address=CONTRACT_ADDRESS, abi=contract_abi)

def get_balance():
    """Get the balance of the account."""
    balance = contract.functions.balanceOf(ACCOUNT_ADDRESS).call()
    print(f"Balance: {balance}")

def send_transaction(to_address, amount):
    """Send tokens to another address."""
    nonce = web3.eth.getTransactionCount(ACCOUNT_ADDRESS)
    transaction = contract.functions.transfer(to_address, amount).buildTransaction({
        'chainId': 1,  # Mainnet
        'gas': 2000000,
        'gasPrice': web3.toWei('50', 'gwei'),
        'nonce': nonce,
    })

    # Sign the transaction
    signed_txn = web3.eth.account.signTransaction(transaction, private_key=PRIVATE_KEY)

    # Send the transaction
    txn_hash = web3.eth.sendRawTransaction(signed_txn.rawTransaction)
    print(f"Transaction sent! Hash: {web3.toHex(txn_hash)}")

def listen_to_events():
    """Listen for Transfer events."""
    event_filter = contract.events.Transfer.createFilter(fromBlock='latest')
    while True:
        for event in event_filter.get_new_entries():
            print(f"Transfer event detected: {event.args}")

if __name__ == "__main__":
    print("1. Get Balance")
    print("2. Send Transaction")
    print("3. Listen to Events")
    choice = input("Choose an option: ")

    if choice == '1':
        get_balance()
    elif choice == '2':
        to_address = input("Enter recipient address: ")
        amount = int(input("Enter amount to send: "))
        send_transaction(to_address, amount)
    elif choice == '3':
        print("Listening for Transfer events...")
        listen_to_events()
    else:
        print("Invalid choice.")
