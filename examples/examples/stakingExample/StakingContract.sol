// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IToken.sol";
import "../libraries/math/SafeMath.sol";

contract StakingContract {
    using SafeMath for uint256;

    IToken public token;
    mapping(address => uint256) public stakedAmount;
    mapping(address => uint256) public rewards;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    constructor(IToken _token) {
        token = _token;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        token.transferFrom(msg.sender, address(this), amount);
        stakedAmount[msg.sender] = stakedAmount[msg.sender].add(amount);
        emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) external {
        require(amount > 0 && stakedAmount[msg.sender] >= amount, "Invalid amount");
        stakedAmount[msg.sender] = stakedAmount[msg.sender].sub(amount);
        token.transfer(msg.sender, amount);
        emit Unstaked(msg.sender, amount);
    }

    function calculateReward(address user) internal view returns (uint256) {
        // Simple reward calculation (1% of staked amount)
        return stakedAmount[user].div(100);
    }

    function claimReward() external {
        uint256 reward = calculateReward(msg.sender);
        require(reward > 0, "No rewards available");
        rewards[msg.sender] = rewards[msg.sender].add(reward);
        token.transfer(msg.sender, reward);
        emit RewardPaid(msg.sender, reward);
    }
}
