const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PriceOracle", function () {
    let priceOracle;

    beforeEach(async function () {
        const priceFeedAddress = "0xYourPriceFeedAddress"; // Replace with actual price feed address
        const fallbackPrice = ethers.utils.parseUnits("100", 18); // Example fallback price

        const PriceOracle = await ethers.getContractFactory("PriceOracle");
        priceOracle = await PriceOracle.deploy(priceFeedAddress, fallbackPrice);
        await priceOracle.deployed();
    });

    it("should return the correct price", async function () {
        const price = await priceOracle.getPrice();
        expect(price).to.equal(ethers.utils.parseUnits("100", 18)); // Adjust based on expected price
    });

    it("should update the price", async function () {
        const newPrice = ethers.utils.parseUnits("150", 18);
        await priceOracle.updatePrice(newPrice);
        const price = await priceOracle.getPrice();
        expect(price).to.equal(newPrice);
    });

    // Add more tests as needed
});
