// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AccessControl {
    mapping(address => bool) private _admins;

    event AdminAdded(address indexed account);
    event AdminRemoved(address indexed account);

    modifier onlyAdmin() {
        require(isAdmin(msg.sender), "AccessControl: caller is not an admin");
        _;
    }

    constructor() {
        _admins[msg.sender] = true; // The deployer is the first admin
        emit AdminAdded(msg.sender);
    }

    function isAdmin(address account) public view returns (bool) {
        return _admins[account];
    }

    function addAdmin(address account) public onlyAdmin {
        _admins[account] = true;
        emit AdminAdded(account);
    }

    function removeAdmin(address account) public onlyAdmin {
        _admins[account] = false;
        emit AdminRemoved(account);
    }
}
