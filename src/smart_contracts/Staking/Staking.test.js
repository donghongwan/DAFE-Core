// Staking.test.js

const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Staking", function () {
    let Token;
    let stakingToken;
    let rewardToken;
    let Staking;
    let staking;
    let owner;
    let addr1;
    let addr2;

    beforeEach(async function () {
        Token = await ethers.getContractFactory("MyAdvancedERC20");
        stakingToken = await Token.deploy("StakingToken", "STK");
        rewardToken = await Token.deploy("RewardToken", "RWD");
        await stakingToken.deployed();
        await rewardToken.deployed();

        // Mint some tokens for testing
        await stakingToken.mint(owner.address, ethers.utils.parseUnits("1000", 18));
        await rewardToken.mint(owner.address, ethers.utils.parseUnits("1000", 18));

        Staking = await ethers.getContractFactory("Staking");
        staking = await Staking.deploy(stakingToken.address, rewardToken.address, ethers.utils.parseUnits("1", 18));
        await staking.deployed();

        // Approve staking tokens
        await stakingToken.approve(staking.address, ethers.utils.parseUnits("1000", 18));
    });

    describe("Staking", function () {
        it("Should stake tokens", async function () {
            await staking.stake(ethers.utils.parseUnits("100", 18));
            const stake = await staking.stakes(owner.address);
            expect(stake.amount).to.equal(ethers.utils.parseUnits("100", 18));
            expect(stake.rewardDebt).to.equal(0);
        });

        it("Should allow multiple stakes", async function () {
            await staking.stake(ethers.utils.parseUnits("100", 18));
            await staking.stake(ethers.utils.parseUnits("200", 18));
            const stake = await staking.stakes(owner.address);
            expect(stake.amount).to.equal(ethers.utils.parseUnits("300", 18));
        });

        it("Should unstake tokens", async function () {
            await staking.stake(ethers.utils.parseUnits("100", 18));
            await staking.unstake(ethers.utils.parseUnits("50", 18));
            const stake = await staking.stakes(owner.address);
            expect(stake.amount).to.equal(ethers.utils.parseUnits("50", 18));
        });

        it("Should not allow unstaking more than staked", async function () {
            await staking.stake(ethers.utils.parseUnits("100", 18));
            await expect(staking.unstake(ethers.utils.parseUnits("150", 18))).to.be.revertedWith("Insufficient staked amount");
        });

        it("Should claim rewards", async function () {
            await staking.stake(ethers.utils.parseUnits("100", 18));
            await ethers.provider.send("evm_increaseTime", [60]); // Increase time by 60 seconds
            await ethers.provider.send("evm_mine"); // Mine a new block
            await staking.claimReward();
            const stake = await staking.stakes(owner.address);
            expect(stake.rewardDebt).to.be.greaterThan(0);
        });

        it("Should not allow claiming rewards if none are available", async function () {
            await staking.stake(ethers.utils.parseUnits("100", 18));
            await expect(staking.claimReward()).to.be.revertedWith("No rewards to claim");
        });

        it("Should calculate pending rewards correctly", async function () {
            await staking.stake(ethers.utils.parseUnits("100", 18));
            await ethers.provider.send("evm_increaseTime", [60]); // Increase time by 60 seconds
            await ethers.provider.send("evm_mine"); // Mine a new block
            const pendingReward = await staking.getPendingReward(owner.address);
            expect(pendingReward).to.be.greaterThan(0);
        });
    });
});
