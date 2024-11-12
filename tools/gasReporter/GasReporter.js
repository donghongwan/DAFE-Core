const { ethers } = require("hardhat");
const fs = require("fs");

async function reportGasUsage(contractName, methodName, ...args) {
    const contract = await ethers.getContractFactory(contractName);
    const instance = await contract.deploy();
    await instance.deployed();

    const tx = await instance[methodName](...args);
    const receipt = await tx.wait();

    const gasUsed = receipt.gasUsed.toString();
    console.log(`Gas used for ${methodName} in ${contractName}: ${gasUsed}`);

    // Optionally, save the report to a file
    fs.appendFileSync("gasReport.txt", `${methodName}: ${gasUsed}\n`);
}

module.exports = { reportGasUsage };
