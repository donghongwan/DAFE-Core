// Governance.test.js

const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Governance", function () {
    let Token;
    let token;
    let Governance;
    let governance;
    let owner;
    let addr1;
    let addr2;

    beforeEach(async function () {
        Token = await ethers.getContractFactory("MyAdvancedERC20");
        token = await Token.deploy("MyToken", "MTK");
        await token.deployed();

        Governance = await ethers.getContractFactory("Governance");
        governance = await Governance.deploy(token.address);
        await governance.deployed();

        [owner, addr1, addr2] = await ethers.getSigners();

        // Mint tokens to the governance contract for testing
        await token.mint(governance.address, 1000);
    });

    describe("Proposal Creation", function () {
        it("Should create a proposal", async function () {
            await governance.createProposal(addr1.address, 100, "Proposal 1");
            const proposal = await governance.getProposal(1);
            expect(proposal.id).to.equal(1);
            expect(proposal.recipient).to.equal(addr1.address);
            expect(proposal.amount).to.equal(100);
            expect(proposal.description).to.equal("Proposal 1");
            expect(proposal.voteCount).to.equal(0);
            expect(proposal.executed).to.equal(false);
        });
    });

    describe("Voting", function () {
        beforeEach(async function () {
            await governance.createProposal(addr1.address, 100, "Proposal 1");
        });

        it("Should allow users to vote", async function () {
            await governance.vote(1);
            const proposal = await governance.getProposal(1);
            expect(proposal.voteCount).to.equal(1);
        });

        it("Should not allow the same user to vote twice", async function () {
            await governance.vote(1);
            await expect(governance.vote(1)). to.be.revertedWith("You have already voted.");
        });

        it("Should not allow voting on executed proposals", async function () {
            await governance.vote(1);
            await governance.executeProposal(1);
            await expect(governance.vote(1)).to.be.revertedWith("Proposal has already been executed.");
        });
    });

    describe("Proposal Execution", function () {
        beforeEach(async function () {
            await governance.createProposal(addr1.address, 100, "Proposal 1");
            await governance.vote(1);
        });

        it("Should execute a proposal", async function () {
            await governance.executeProposal(1);
            const proposal = await governance.getProposal(1);
            expect(proposal.executed).to.equal(true);
            expect(await token.balanceOf(addr1.address)).to.equal(100);
        });

        it("Should not execute a proposal with no votes", async function () {
            await governance.createProposal(addr2.address, 100, "Proposal 2");
            await expect(governance.executeProposal(2)).to.be.revertedWith("No votes for this proposal.");
        });

        it("Should not execute a proposal that has already been executed", async function () {
            await governance.executeProposal(1);
            await expect(governance.executeProposal(1)).to.be.revertedWith("Proposal has already been executed.");
        });
    });
});
