// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract LendingPool is Pausable {
    using SafeMath for uint256;

    IERC20 public token; // The token being lent
    uint256 public interestRate; // Annual interest rate in basis points (1% = 100)
    uint256 public constant BASIS_POINTS = 10000; // 100% in basis points

    struct User {
        uint256 depositedAmount;
        uint256 borrowedAmount;
        uint256 collateralAmount;
    }

    mapping(address => User) public users;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event Borrowed(address indexed user, uint256 amount);
    event Repaid(address indexed user, uint256 amount);
    event Liquidated(address indexed user, uint256 amount);

    constructor(IERC20 _token, uint256 _interestRate) {
        token = _token;
        interestRate = _interestRate;
    }

    function deposit(uint256 amount) external whenNotPaused {
        require(amount > 0, "Amount must be greater than zero");
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        users[msg.sender].depositedAmount = users[msg.sender].depositedAmount.add(amount);
        emit Deposited(msg.sender, amount);
    }

    function withdraw(uint256 amount) external whenNotPaused {
        User storage user = users[msg.sender];
        require(user.depositedAmount >= amount, "Insufficient balance");

        user.depositedAmount = user.depositedAmount.sub(amount);
        require(token.transfer(msg.sender, amount), "Transfer failed");
        emit Withdrawn(msg.sender, amount);
    }

    function borrow(uint256 amount) external whenNotPaused {
        User storage user = users[msg.sender];
        require(user.depositedAmount > 0, "No collateral deposited");
        require(user.borrowedAmount.add(amount) <= user.depositedAmount.mul(50).div(100), "Borrowing limit exceeded");

        user.borrowedAmount = user.borrowedAmount.add(amount);
        require(token.transfer(msg.sender, amount), "Transfer failed");
        emit Borrowed(msg.sender, amount);
    }

    function repay(uint256 amount) external whenNotPaused {
        User storage user = users[msg.sender];
        require(user.borrowedAmount >= amount, "Repayment exceeds borrowed amount");

        user.borrowedAmount = user.borrowedAmount.sub(amount);
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        emit Repaid(msg.sender, amount);
    }

    function liquidate(address userAddress) external whenNotPaused {
        User storage user = users[userAddress];
        require(user.borrowedAmount > 0, "No outstanding loans");
        require(user.depositedAmount < user.borrowedAmount.mul(200).div(100), "Loan is sufficiently collateralized");

        uint256 amountToLiquidate = user.borrowedAmount;
        user.borrowedAmount = 0;
        user.depositedAmount = user.depositedAmount.sub(amountToLiquidate);

        require(token.transfer(msg.sender, amountToLiquidate), "Transfer failed");
        emit Liquidated(userAddress, amountToLiquidate);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function setInterestRate(uint256 _interestRate) external onlyOwner {
        interestRate = _interestRate;
    }
}
