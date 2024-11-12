// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGovernance {
    function propose(string calldata description) external returns (uint256);
    function vote(uint256 proposalId, bool support) external;
    function execute(uint256 proposalId) external;

    function getProposal(uint256 proposalId) external view returns (
        string memory description,
        uint256 voteCountFor,
        uint256 voteCountAgainst,
        bool executed
    );

    event ProposalCreated(uint256 indexed proposalId, string description);
    event Voted(uint256 indexed proposalId, address indexed voter, bool support);
    event ProposalExecuted(uint256 indexed proposalId);
}
