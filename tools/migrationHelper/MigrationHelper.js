const { ethers } = require("hardhat");

async function deployContract(contractName, args) {
    const Contract = await ethers.getContractFactory(contractName);
    const contract = await Contract.deploy(...args);
    await contract.deployed();
    console.log(`${contractName} deployed to: ${contract.address}`);
    return contract.address;
}

async function migrateContracts() {
    const tokenAddress = await deployContract("Token", ["TOKEN_NAME", "TKN", 1000000]);
    const stakingAddress = await deployContract("StakingContract", [tokenAddress]);
    const lendingAddress = await deployContract("LendingContract", [tokenAddress]);

    console.log("Migration complete!");
    console.log(`Token Address: ${tokenAddress}`);
    console.log(`Staking Contract Address: ${stakingAddress}`);
    console.log(`Lending Contract Address: ${lendingAddress}`);
}

module.exports = { migrateContracts };
