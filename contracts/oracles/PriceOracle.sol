// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceOracle is Ownable, Pausable {
    AggregatorV3Interface internal priceFeed; // Chainlink price feed
    uint256 public fallbackPrice; // Fallback price in case of feed failure

    event PriceUpdated(uint256 newPrice);
    event FallbackPriceSet(uint256 fallbackPrice);

    constructor(address _priceFeed, uint256 _fallbackPrice) {
        priceFeed = AggregatorV3Interface(_priceFeed);
        fallbackPrice = _fallbackPrice;
    }

    function getLatestPrice() public view whenNotPaused returns (uint256) {
        try priceFeed.latestRoundData() returns (
            uint80 /* roundId */,
            int256 price,
            uint256 /* startedAt */,
            uint256 /* timeStamp */,
            uint80 /* answeredInRound */
        ) {
            require(price > 0, "Invalid price");
            return uint256(price);
        } catch {
            return fallbackPrice; // Return fallback price if price feed fails
        }
    }

    function setPriceFeed(address _priceFeed) external onlyOwner {
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function setFallbackPrice(uint256 _fallbackPrice) external onlyOwner {
        fallbackPrice = _fallbackPrice;
        emit FallbackPriceSet(_fallbackPrice);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
