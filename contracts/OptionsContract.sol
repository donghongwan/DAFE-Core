// contracts/OptionsContract.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OptionsContract {
    event OptionCreated(uint indexed optionId, address indexed creator, uint strikePrice, uint expiration);
    event OptionExercised(uint indexed optionId, address indexed holder);
    
    struct Option {
        address creator;
        address holder;
        uint strikePrice;
        uint expiration;
        bool exercised;
    }

    Option[] public options;

    function createOption(uint _strikePrice, uint _expiration) public {
        require(_expiration > block.timestamp, "Expiration must be in the future");
        Option storage newOption = options.push();
        newOption.creator = msg.sender;
        newOption.strikePrice = _strikePrice;
        newOption.expiration = _expiration;
        newOption.holder = msg.sender; // Initially, the creator is the holder
        emit OptionCreated(options.length - 1, msg.sender, _strikePrice, _expiration);
    }

    function exerciseOption(uint _optionId) public {
        require(_optionId < options.length, "Option does not exist");
        Option storage option = options[_optionId];
        require(msg.sender == option.holder, "Not the holder of the option");
        require(block.timestamp < option.expiration, "Option has expired");
        require(!option.exercised, "Option already exercised");

        option.exercised = true;
        emit OptionExercised(_optionId, msg.sender);
        // Logic to transfer assets based on the option terms goes here
    }
}
