// ERC20.test.js

const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MyAdvancedERC20", function () {
    let Token;
    let myToken;
    let owner;
    let addr1;
    let addr2;

    beforeEach(async function () {
        Token = await ethers.getContractFactory("MyAdvancedERC20");
        [owner, addr1, addr2] = await ethers.getSigners();
        myToken = await Token.deploy("MyToken", "MTK");
        await myToken.deployed();
    });

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            expect(await myToken.owner()).to.equal(owner.address);
        });

        it("Should mint initial supply to the owner", async function () {
            const ownerBalance = await myToken.balanceOf(owner.address);
            expect(await myToken.totalSupply()).to.equal(ownerBalance);
        });
    });

    describe("Transactions", function () {
        it("Should transfer tokens between accounts", async function () {
            await myToken.transfer(addr1.address, 50);
            const addr1Balance = await myToken.balanceOf(addr1.address);
            expect(addr1Balance).to.equal(50);

            await myToken.connect(addr1).transfer(addr2.address, 50);
            const addr2Balance = await myToken.balanceOf(addr2.address);
            expect(addr2Balance).to.equal(50);
        });

        it("Should fail if sender does not have enough tokens", async function () {
            const initialOwnerBalance = await myToken.balanceOf(owner.address);
            await expect(
                myToken.connect(addr1).transfer(owner.address, 1)
            ).to.be.revertedWith("ERC20: transfer amount exceeds balance");

            // Owner balance should not have changed
            expect(await myToken.balanceOf(owner.address)).to.equal(initialOwnerBalance);
        });
    });

    describe("Minting and Burning", function () {
        it("Should mint new tokens", async function () {
            await myToken.mint(addr1.address, 100);
            expect(await myToken.balanceOf(addr1.address)).to.equal(100);
        });

        it("Should burn tokens", async function () {
            await myToken.connect(addr1).transfer(addr 1.address, 100);
            await myToken.connect(addr1).burn(50);
            expect(await myToken.balanceOf(addr1.address)).to.equal(50);
        });
    });

    describe("Pausable", function () {
        it("Should pause and unpause the contract", async function () {
            await myToken.pause();
            await expect(myToken.transfer(addr1.address, 50)).to.be.revertedWith("Pausable: paused");

            await myToken.unpause();
            await myToken.transfer(addr1.address, 50);
            expect(await myToken.balanceOf(addr1.address)).to.equal(50);
        });
    });

    describe("Freezing Accounts", function () {
        it("Should freeze and unfreeze accounts", async function () {
            await myToken.freezeAccount(addr1.address);
            await expect(myToken.connect(addr1).transfer(addr2.address, 50)).to.be.revertedWith("ERC20: account is frozen");

            await myToken.unfreezeAccount(addr1.address);
            await myToken.connect(addr1).transfer(addr2.address, 50);
            expect(await myToken.balanceOf(addr2.address)).to.equal(50);
        });
    });
});
