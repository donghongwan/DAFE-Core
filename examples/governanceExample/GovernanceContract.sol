// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IGovernance.sol";
import "../interfaces/IToken.sol";

contract GovernanceContract is IGovernance {
    struct Proposal {
        string description;
        uint256 voteCountFor;
        uint256 voteCountAgainst;
        bool executed;
    }

    IToken public token;
    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    event ProposalCreated(uint256 indexed proposalId, string description);
    event Voted(uint256 indexed proposalId, address indexed voter, bool support);
    event ProposalExecuted(uint256 indexed proposalId);

    constructor(IToken _token) {
        token = _token;
    }

    function propose(string calldata description) external override returns (uint256) {
        proposalCount++;
        proposals[proposalCount] = Proposal(description, 0, 0, false);
        emit ProposalCreated(proposalCount, description);
        return proposalCount;
    }

    function vote(uint256 proposalId, bool support) external ```solidity
    {
        require(proposalId > 0 && proposalId <= proposalCount, "Invalid proposal ID");
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Proposal already executed");

        if (support) {
            proposal.voteCountFor++;
        } else {
            proposal.voteCountAgainst++;
        }
        emit Voted(proposalId, msg.sender, support);
    }

    function executeProposal(uint256 proposalId) external {
        require(proposalId > 0 && proposalId <= proposalCount, "Invalid proposal ID");
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(proposal.voteCountFor > proposal.voteCountAgainst, "Proposal not approved");

        // Execute the proposal logic here (e.g., changing a parameter)
        proposal.executed = true;
        emit ProposalExecuted(proposalId);
    }
}
