// contracts/MultiSigWallet.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet {
    event Deposit(address indexed sender, uint amount);
    event SubmitTransaction(address indexed owner, uint indexed txIndex);
    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint indexed txIndex);

    address[] public owners;
    mapping(address => bool) public isOwner;
    mapping(uint => mapping(address => bool)) public isConfirmed;
    mapping(uint => Transaction) public transactions;
    uint public numConfirmationsRequired;
    uint public transactionCount;

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
    }

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not an owner");
        _;
    }

    modifier txExists(uint _txIndex) {
        require(_txIndex < transactionCount, "Transaction does not exist");
        _;
    }

    modifier notExecuted(uint _txIndex) {
        require(!transactions[_txIndex].executed, "Transaction already executed");
        _;
    }

    modifier notConfirmed(uint _txIndex) {
        require(!isConfirmed[_txIndex][msg.sender], "Transaction already confirmed");
        _;
    }

    constructor(address[] memory _owners, uint _numConfirmationsRequired) {
        require(_owners.length > 0, "Owners required");
        require(_numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length, "Invalid number of confirmations");

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner");
            require(!isOwner[owner], "Owner is not unique");
            isOwner[owner] = true;
            owners.push(owner);
        }
        numConfirmationsRequired = _numConfirmationsRequired;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function submitTransaction(address _to, uint _value, bytes memory _data) public onlyOwner {
        uint txIndex = transactionCount;
        transactions[txIndex] = Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false
        });
        transactionCount++;
        emit SubmitTransaction(msg.sender, txIndex);
    }

    function confirmTransaction(uint _txIndex) public onlyOwner txExists(_txIndex) notConfirmed(_txIndex) {
        isConfirmed[_txIndex][msg.sender] = true;
        emit ConfirmTransaction(msg.sender, _txIndex);
        executeTransaction(_txIndex);
    }

    function executeTransaction(uint _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        require(getConfirmationCount(_txIndex) >= numConfirmationsRequired, "Not enough confirmations");
        Transaction storage transaction = transactions[_txIndex];
        transaction.executed = true;
        (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "Transaction failed");
        emit ExecuteTransaction(msg.sender, _txIndex);
    }

    function getConfirmationCount(uint _txIndex) public view returns (uint count) {
        for (uint i = 0; i < owners.length; i++) {
            if (isConfirmed[_txIndex][owners[i]]) {
                count++;
            }
        }
    }
}
