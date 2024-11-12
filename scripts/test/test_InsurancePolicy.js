const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("InsurancePolicy", function () {
    let insurancePolicy;
    let premiumToken;

    beforeEach(async function () {
        const PremiumToken = await ethers.getContractFactory("YourERC20Token"); // Replace with your ERC20 token contract
        premiumToken = await PremiumToken.deploy();
        await premiumToken.deployed();

        const InsurancePolicy = await ethers.getContractFactory("InsurancePolicy");
        insurancePolicy = await InsurancePolicy.deploy(premiumToken.address);
        await insurancePolicy.deployed();
    });

    it("should create a policy", async function () {
        // Add your test logic here
    });

    it("should file a claim", async function () {
        // Add your test logic here
    });

    // Add more tests as needed
});
