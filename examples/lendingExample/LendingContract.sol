// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IToken.sol";

contract LendingContract {
    IToken public token;
    mapping(address => uint256) public deposits;
    mapping(address => uint256) public loans;

    event Deposited(address indexed user, uint256 amount);
    event Loaned(address indexed user, uint256 amount);
    event Repaid(address indexed user, uint256 amount);

    constructor(IToken _token) {
        token = _token;
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        token.transferFrom(msg.sender, address(this), amount);
        deposits[msg.sender] += amount;
        emit Deposited(msg.sender, amount);
    }

    function loan(uint256 amount) external {
        require(deposits[msg.sender] >= amount, "Insufficient deposit");
        loans[msg.sender] += amount;
        token.transfer(msg.sender, amount);
        emit Loaned(msg.sender, amount);
    }

    function repay(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        token.transferFrom(msg.sender, address(this), amount);
        loans[msg.sender] -= amount;
        emit Repaid(msg.sender, amount);
    }
}
