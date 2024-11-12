// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract InsurancePolicy is Ownable, Pausable {
    using SafeMath for uint256;

    struct Policy {
        uint256 coverageAmount;
        uint256 premium;
        uint256 startTime;
        uint256 duration; // Duration in seconds
        bool isActive;
        bool isClaimed;
    }

    mapping(address => Policy) public policies;
    IERC20 public premiumToken; // Token used for paying premiums

    event PolicyCreated(address indexed user, uint256 coverageAmount, uint256 premium, uint256 duration);
    event ClaimFiled(address indexed user);
    event ClaimApproved(address indexed user, uint256 payoutAmount);
    event ClaimDenied(address indexed user);

    constructor(IERC20 _premiumToken) {
        premiumToken = _premiumToken;
    }

    function createPolicy(uint256 coverageAmount, uint256 premium, uint256 duration) external whenNotPaused {
        require(coverageAmount > 0, "Coverage amount must be greater than zero");
        require(premium > 0, "Premium must be greater than zero");
        require(duration > 0, "Duration must be greater than zero");
        require(!policies[msg.sender].isActive, "Existing active policy found");

        // Transfer premium to the contract
        require(premiumToken.transferFrom(msg.sender, address(this), premium), "Premium payment failed");

        policies[msg.sender] = Policy({
            coverageAmount: coverageAmount,
            premium: premium,
            startTime: block.timestamp,
            duration: duration,
            isActive: true,
            isClaimed: false
        });

        emit PolicyCreated(msg.sender, coverageAmount, premium, duration);
    }

    function fileClaim() external whenNotPaused {
        Policy storage policy = policies[msg.sender];
        require(policy.isActive, "No active policy found");
        require(!policy.isClaimed, "Claim already filed");

        policy.isClaimed = true; // Mark claim as filed
        emit ClaimFiled(msg.sender);
    }

    function approveClaim(address user) external onlyOwner whenNotPaused {
        Policy storage policy = policies[user];
        require(policy.isActive, "No active policy found");
        require(policy.isClaimed, "No claim filed");

        uint256 payoutAmount = policy.coverageAmount;
        policy.isActive = false; // Mark policy as inactive after claim approval
        policy.isClaimed = false; // Reset claim status

        require(premiumToken.transfer(user, payoutAmount), "Payout transfer failed");
        emit ClaimApproved(user, payoutAmount);
    }

    function denyClaim(address user) external onlyOwner whenNotPaused {
        Policy storage policy = policies[user];
        require(policy.isActive, "No active policy found");
        require(policy.isClaimed, "No claim filed");

        policy.isClaimed = false; // Reset claim status
        emit ClaimDenied(user);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
