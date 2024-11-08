// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract MyAdvancedERC20 is ERC20, Ownable, Pausable {
    // Mapping from account to frozen status
    mapping(address => bool) private _frozenAccounts;

    event FrozenFunds(address target, bool frozen);

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        // Initial minting to the contract deployer
        _mint(msg.sender, 1000000 * 10 ** decimals()); // Mint 1 million tokens
    }

    // Function to mint new tokens
    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }

    // Function to burn tokens
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    // Function to pause all token transfers
    function pause() public onlyOwner {
        _pause();
    }

    // Function to unpause all token transfers
    function unpause() public onlyOwner {
        _unpause();
    }

    // Function to freeze an account
    function freezeAccount(address target) public onlyOwner {
        _frozenAccounts[target] = true;
        emit FrozenFunds(target, true);
    }

    // Function to unfreeze an account
    function unfreezeAccount(address target) public onlyOwner {
        _frozenAccounts[target] = false;
        emit FrozenFunds(target, false);
    }

    // Override transfer function to prevent transfers from frozen accounts
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override whenNotPaused {
        require(!_frozenAccounts[from], "ERC20: account is frozen");
        super._beforeTokenTransfer(from, to, amount);
    }
}
