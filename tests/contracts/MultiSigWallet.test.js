// tests/contracts/MultiSigWallet.test.js
const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('MultiSigWallet', function () {
    let MultiSigWallet;
    let multiSigWallet;
    let owner1, owner2, owner3;
    const owners = [];
    const requiredConfirmations = 2;

    beforeEach(async function () {
        [owner1, owner2, owner3] = await ethers.getSigners();
        owners.push(owner1.address, owner2.address, owner3.address);

        MultiSigWallet = await ethers.getContractFactory('MultiSigWallet');
        multiSigWallet = await MultiSigWallet.deploy(owners, requiredConfirmations);
        await multiSigWallet.deployed();
    });

    it('should add owners correctly', async function () {
        const walletOwners = await multiSigWallet.getOwners();
        expect(walletOwners).to.deep.equal(owners);
    });

    it('should submit a transaction', async function () {
        const tx = await multiSigWallet.connect(owner1).submitTransaction(owner2.address, ethers.utils.parseEther('1.0'));
        await tx.wait();

        const transaction = await multiSigWallet.transactions(0);
        expect(transaction.to).to.equal(owner2.address);
        expect(transaction.value.toString()).to.equal(ethers.utils.parseEther('1.0').toString());
        expect(transaction.executed).to.be.false;
    });

    it('should execute a transaction with enough confirmations', async function () {
        await multiSigWallet.connect(owner1).submitTransaction(owner2.address, ethers.utils.parseEther('1.0'));
        await multiSigWallet.connect(owner1).confirmTransaction(0);
        await multiSigWallet.connect(owner2).confirmTransaction(0);

        const tx = await multiSigWallet.connect(owner1).executeTransaction(0);
        await tx.wait();

        const transaction = await multiSigWallet.transactions(0);
        expect(transaction.executed).to.be.true;
    });

    it('should not execute a transaction without enough confirmations', async function () {
        await multiSigWallet.connect(owner1).submitTransaction(owner2.address, ethers.utils.parseEther('1.0'));
        await multiSigWallet.connect(owner1).confirmTransaction(0);

        await expect(multiSigWallet.connect(owner3).executeTransaction(0)).to.be.revertedWith('Not enough confirmations');
    });
});
