// contracts/Governance.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Governance {
    event ProposalCreated(uint indexed proposalId, address indexed proposer, string description);
    event Voted(uint indexed proposalId, address indexed voter, bool support);
    event ProposalExecuted(uint indexed proposalId);

    struct Proposal {
        address proposer;
        string description;
        uint voteCount;
        uint againstCount;
        mapping(address => bool) votes;
        bool executed;
    }

    Proposal[] public proposals;
    uint public votingPeriod;
    mapping(address => uint) public lastVote;

    constructor(uint _votingPeriod) {
        votingPeriod = _votingPeriod;
    }

    function createProposal(string memory _description) public {
        Proposal storage newProposal = proposals.push();
        newProposal.proposer = msg.sender;
        newProposal.description = _description;
        emit ProposalCreated(proposals.length - 1, msg.sender, _description);
    }

    function vote(uint _proposalId, bool _support) public {
        require(_proposalId < proposals.length, "Proposal does not exist");
        require(lastVote[msg.sender] < block.timestamp - votingPeriod, "Voting period has not ended");

        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.votes[msg.sender], "Already voted");

        if (_support) {
            proposal.voteCount++;
        } else {
            proposal.againstCount++;
        }
        proposal.votes[msg.sender] = true;
        lastVote[msg.sender] = block.timestamp;

        emit Voted(_proposalId, msg.sender, _support);
    }

    function executeProposal(uint _proposalId) public {
        require(_proposalId < proposals.length, "Proposal does not exist");
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(proposal.voteCount > proposal.againstCount, "Proposal not approved");

        proposal.executed = true;
        emit ProposalExecuted(_proposalId);
        // Logic to execute the proposal goes here
    }
}
