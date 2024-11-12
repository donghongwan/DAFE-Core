// contracts/FuturesContract.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FuturesContract {
    event FutureCreated(uint indexed futureId, address indexed creator, uint price, uint expiration);
    event FutureSettled(uint indexed futureId, address indexed holder, uint finalPrice);

    struct Future {
        address creator;
        address holder;
        uint price;
        uint expiration;
        bool settled;
        uint finalPrice;
    }

    Future[] public futures;

    function createFuture(uint _price, uint _expiration) public {
        require(_expiration > block.timestamp, "Expiration must be in the future");
        Future storage newFuture = futures.push();
        newFuture.creator = msg.sender;
        newFuture.price = _price;
        newFuture.expiration = _expiration;
        newFuture.holder = msg.sender; // Initially, the creator is the holder
        emit FutureCreated(futures.length - 1, msg.sender, _price, _expiration);
    }

    function settleFuture(uint _futureId, uint _finalPrice) public {
        require(_futureId < futures.length, "Future does not exist");
        Future storage future = futures[_futureId];
        require(msg.sender == future.holder, "Not the holder of the future");
        require(block.timestamp >= future.expiration, "Future has not expired");
        require(!future.settled, "Future already settled");

        future.finalPrice = _finalPrice;
        future.settled = true;
        emit FutureSettled(_futureId, msg.sender, _finalPrice);
        // Logic to settle the future contract goes here
    }
}
