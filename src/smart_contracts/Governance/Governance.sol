// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Governance is Ownable {
    IERC20 public token;

    struct Proposal {
        uint256 id;
        address recipient;
        uint256 amount;
        string description;
        uint256 voteCount;
        mapping(address => bool) voters;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    event ProposalCreated(uint256 id, address recipient, uint256 amount, string description);
    event Voted(uint256 proposalId, address voter);
    event ProposalExecuted(uint256 proposalId);

    constructor(IERC20 _token) {
        token = _token;
    }

    function createProposal(address recipient, uint256 amount, string memory description) external onlyOwner {
        proposalCount++;
        Proposal storage newProposal = proposals[proposalCount];
        newProposal.id = proposalCount;
        newProposal.recipient = recipient;
        newProposal.amount = amount;
        newProposal.description = description;
        newProposal.executed = false;

        emit ProposalCreated(proposalCount, recipient, amount, description);
    }

    function vote(uint256 proposalId) external {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.voters[msg.sender], "You have already voted.");
        require(!proposal.executed, "Proposal has already been executed.");

        proposal.voters[msg.sender] = true;
        proposal.voteCount++;

        emit Voted(proposalId, msg.sender);
    }

    function executeProposal(uint256 proposalId) external {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.voteCount > 0, "No votes for this proposal.");
        require(!proposal.executed, "Proposal has already been executed.");

        // Transfer tokens to the recipient
        require(token.balanceOf(address(this)) >= proposal.amount, "Insufficient balance in contract.");
        token.transfer(proposal.recipient, proposal.amount);
        proposal.executed = true;

        emit ProposalExecuted(proposalId);
    }

    function getProposal(uint256 proposalId) external view returns (Proposal memory) {
        return proposals[proposalId];
    }
}
