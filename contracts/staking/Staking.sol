// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Staking is Pausable {
    using SafeMath for uint256;

    IERC20 public stakingToken; // The token being staked
    uint256 public rewardRate; // Reward rate per second in tokens
    uint256 public earlyWithdrawalPenalty; // Penalty percentage for early withdrawal

    struct Stake {
        uint256 amount;
        uint256 startTime;
        uint256 rewards;
    }

    mapping(address => Stake) public stakes;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardClaimed(address indexed user, uint256 amount);

    constructor(IERC20 _stakingToken, uint256 _rewardRate, uint256 _earlyWithdrawalPenalty) {
        stakingToken = _stakingToken;
        rewardRate = _rewardRate;
        earlyWithdrawalPenalty = _earlyWithdrawalPenalty;
    }

    function stake(uint256 amount) external whenNotPaused {
        require(amount > 0, "Amount must be greater than zero");
        require(stakingToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        Stake storage userStake = stakes[msg.sender];

        // Calculate rewards for the previous stake
        if (userStake.amount > 0) {
            userStake.rewards = userStake.rewards.add(calculateRewards(msg.sender));
        }

        userStake.amount = userStake.amount.add(amount);
        userStake.startTime = block.timestamp;

        emit Staked(msg.sender, amount);
    }

    function withdraw(uint256 amount) external whenNotPaused {
        Stake storage userStake = stakes[msg.sender];
        require(userStake.amount >= amount, "Insufficient staked amount");

        // Calculate rewards before withdrawal
        userStake.rewards = userStake.rewards.add(calculateRewards(msg.sender));

        // Apply early withdrawal penalty if applicable
        if (block.timestamp < userStake.startTime + 30 days) { // 30 days lock period
            uint256 penalty = amount.mul(earlyWithdrawalPenalty).div(100);
            amount = amount.sub(penalty);
        }

        userStake.amount = userStake.amount.sub(amount);
        require(stakingToken.transfer(msg.sender, amount), "Transfer failed");

        emit Withdrawn(msg.sender, amount);
    }

    function claimRewards() external whenNotPaused {
        Stake storage userStake = stakes[msg.sender];
        uint256 rewards = userStake.rewards.add(calculateRewards(msg.sender));
        require(rewards > 0, "No rewards to claim");

        userStake.rewards = 0; // Reset rewards after claiming
        require(stakingToken.transfer(msg.sender, rewards), "Transfer failed");

        emit RewardClaimed(msg.sender, rewards);
    }

    function calculateRewards(address user) internal view returns (uint256) {
        Stake storage userStake = stakes[user];
        return userStake.amount.mul(rewardRate).mul(block.timestamp.sub(userStake.startTime)).div(1e18);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function setRewardRate(uint256 _rewardRate) external onlyOwner {
        rewardRate = _rewardRate;
    }

    function setEarlyWithdrawalPenalty(uint256 _penalty) external onlyOwner {
        earlyWithdrawalPenalty = _penalty;
    }
}
