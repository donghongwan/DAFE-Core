// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Staking is Ownable {
    IERC20 public stakingToken;
    IERC20 public rewardToken;

    struct Stake {
        uint256 amount;
        uint256 rewardDebt;
        uint256 lastStakedTime;
    }

    mapping(address => Stake) public stakes;
    uint256 public totalStaked;
    uint256 public rewardRate; // Reward tokens per second
    uint256 public lastUpdateTime;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    constructor(IERC20 _stakingToken, IERC20 _rewardToken, uint256 _rewardRate) {
        stakingToken = _stakingToken;
        rewardToken = _rewardToken;
        rewardRate = _rewardRate;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Cannot stake 0");
        updateReward(msg.sender);

        stakes[msg.sender].amount += amount;
        stakes[msg.sender].lastStakedTime = block.timestamp;
        totalStaked += amount;

        stakingToken.transferFrom(msg.sender, address(this), amount);
        emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) external {
        require(amount > 0, "Cannot unstake 0");
        require(stakes[msg.sender].amount >= amount, "Insufficient staked amount");

        updateReward(msg.sender);

        stakes[msg.sender].amount -= amount;
        totalStaked -= amount;

        stakingToken.transfer(msg.sender, amount);
        emit Unstaked(msg.sender, amount);
    }

    function claimReward() external {
        updateReward(msg.sender);
        uint256 reward = stakes[msg.sender].rewardDebt;
        require(reward > 0, "No rewards to claim");

        stakes[msg.sender].rewardDebt = 0;
        rewardToken.transfer(msg.sender, reward);
        emit RewardPaid(msg.sender, reward);
    }

    function updateReward(address user) internal {
        uint256 timeDiff = block.timestamp - lastUpdateTime;
        if (totalStaked > 0) {
            uint256 reward = (timeDiff * rewardRate * stakes[user].amount) / totalStaked;
            stakes[user].rewardDebt += reward;
        }
        lastUpdateTime = block.timestamp;
    }

    function getPendingReward(address user) external view returns (uint256) {
        uint256 timeDiff = block.timestamp - lastUpdateTime;
        uint256 reward = (timeDiff * rewardRate * stakes[user].amount) / totalStaked;
        return stakes[user].rewardDebt + reward;
    }
}
