const { ethers } = require("hardhat");

async function main() {
    const PremiumToken = await ethers.getContractFactory("YourERC20Token"); // Replace with your ERC20 token contract
    const premiumToken = await PremiumToken.deploy();
    await premiumToken.deployed();

    const InsurancePolicy = await ethers.getContractFactory("InsurancePolicy");
    const insurancePolicy = await InsurancePolicy.deploy(premiumToken.address);
    await insurancePolicy.deployed();

    console.log("Premium Token deployed to:", premiumToken.address);
    console.log("Insurance Policy deployed to:", insurancePolicy.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
