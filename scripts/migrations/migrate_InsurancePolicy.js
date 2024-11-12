const { ethers } = require("hardhat");

async function main() {
    const InsurancePolicy = await ethers.getContractFactory("InsurancePolicy");
    const insurancePolicy = await InsurancePolicy.deploy("0xYourPremiumTokenAddress"); // Replace with actual token address
    await insurancePolicy.deployed();

    console.log("Insurance Policy migrated to:", insurancePolicy.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
