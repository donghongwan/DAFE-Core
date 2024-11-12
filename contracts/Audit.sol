// contracts/Audit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Audit {
    event AuditLog(address indexed auditor, string message, uint timestamp);

    function logAudit(string memory _message) public {
        emit AuditLog(msg.sender, _message, block.timestamp);
    }

    function getAuditLogs() public view returns (string[] memory) {
        // Logic to retrieve audit logs goes here
    }
}
