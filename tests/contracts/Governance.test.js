// tests/contracts/Governance.test.js
const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('Governance', function () {
    let Governance;
    let governance;
    let owner, voter1, voter2;
    const proposalDescription = "Increase the token supply";

    beforeEach(async function () {
        [owner, voter1, voter2] = await ethers.getSigners();

        Governance = await ethers.getContractFactory('Governance');
        governance = await Governance.deploy();
        await governance.deployed();
    });

    it('should propose a new action', async function () {
        await governance.connect(owner).propose(proposalDescription);
        const proposal = await governance.proposals(0);
        expect(proposal.description).to.equal(proposalDescription);
        expect(proposal.voteCount).to.equal(0);
        expect(proposal.executed).to.be.false;
    });

    it('should allow voting on a proposal', async function () {
        await governance.connect(owner).propose(proposalDescription);
        await governance.connect(voter1).vote(0);
        const proposal = await governance.proposals(0);
        expect(proposal.voteCount).to.equal(1);
    });

    it('should execute a proposal if it has enough votes', async function () {
        await governance.connect(owner).propose(proposalDescription);
        await governance.connect(voter1).vote(0);
        await governance.connect(voter2).vote(0);

        await governance.connect(owner).executeProposal(0);
        const proposal = await governance.proposals(0);
        expect(proposal.executed).to.be.true;
    });

    it('should not execute a proposal without enough votes', async function () {
        await governance.connect(owner).propose(proposalDescription);
        await expect(governance.connect(owner).executeProposal(0)).to.be.revertedWith('Not enough votes');
    });
});
