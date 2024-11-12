// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract DAO is Ownable {
    using Address for address;

    IERC20 public governanceToken;
    uint256 public quorum; // Minimum votes required to pass a proposal
    uint256 public timelock; // Time delay for executing proposals

    struct Proposal {
        string description;
        uint256 voteCount;
        uint256 creationTime;
        bool executed;
        mapping(address => bool) voted;
        bytes callData; // Data for executing the proposal
        address target; // Target contract for execution
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    event ProposalCreated(uint256 proposalId, string description, address target, bytes callData);
    event Voted(uint256 proposalId, address voter, uint256 votes);
    event ProposalExecuted(uint256 proposalId);

    constructor(IERC20 _governanceToken, uint256 _quorum, uint256 _timelock) {
        governanceToken = _governanceToken;
        quorum = _quorum;
        timelock = _timelock;
    }

    function createProposal(string memory description, address target, bytes memory callData) external onlyOwner {
        proposalCount++;
        Proposal storage newProposal = proposals[proposalCount];
        newProposal.description = description;
        newProposal.target = target;
        newProposal.callData = callData;
        newProposal.creationTime = block.timestamp;
        newProposal.executed = false;

        emit ProposalCreated(proposalCount, description, target, callData);
    }

    function vote(uint256 proposalId, uint256 amount) external {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(!proposal.voted[msg.sender], "Already voted");
        require(governanceToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        proposal.voteCount += amount;
        proposal.voted[msg.sender] = true;

        emit Voted(proposalId, msg.sender, amount);
    }

    function executeProposal(uint256 proposalId) external {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(proposal.voteCount >= quorum, "Not enough votes");
        require(block.timestamp >= proposal.creationTime + timelock, "Timelock not expired");

        // Execute the proposal
        (bool success, ) = proposal.target.call(proposal.callData);
        require(success, "Proposal execution failed");

        proposal.executed = true;
        emit ProposalExecuted(proposalId);
    }

    function setQuorum(uint256 _quorum) external onlyOwner {
        quorum = _quorum;
    }

    function setTimelock(uint256 _timelock) external onlyOwner {
        timelock = _timelock;
    }
}
