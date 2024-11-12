const { ethers } = require("hardhat");

async function main() {
    const priceFeedAddress = "0xYourPriceFeedAddress"; // Replace with actual price feed address
    const fallbackPrice = ethers.utils.parseUnits("100", 18); // Example fallback price

    const PriceOracle = await ethers.getContractFactory("PriceOracle");
    const priceOracle = await PriceOracle.deploy(priceFeedAddress, fallbackPrice);
    await priceOracle.deployed();

    console.log("Price Oracle deployed to:", priceOracle.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
