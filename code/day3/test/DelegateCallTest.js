const {
    time,
    loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("TargetContract and CallLearn", function () {

    async function deployCallLearn() {

        const [owner, otherAccount] = await ethers.getSigners();

        const TargetDelegateCallContract = await ethers.getContractFactory("TargetDelegateCallContract");
        const targetDelegateCallContract = await TargetDelegateCallContract.deploy();

        const DelegateCallTest = await ethers.getContractFactory("DelegateCallTest");
        const delegateCallTest = await DelegateCallTest.deploy();


        return { targetDelegateCallContract,  delegateCallTest, owner, otherAccount };
    }

    describe("TargetContract and CallLearn test script", function () {
        it("call test for before and after", async function () {
            const { targetDelegateCallContract,  delegateCallTest, owner, otherAccount  } = await loadFixture(deployCallLearn);
            const targetDataBefore = await targetDelegateCallContract.data()
            console.log("targetDataBefore===", targetDataBefore)


            const delegateDataBefore = await delegateCallTest.data()
            console.log("delegateDataBefore===", delegateDataBefore)

            await delegateCallTest.delegateCallSetData(targetDelegateCallContract, 5)


            const targetDataAfter = await targetDelegateCallContract.data()
            console.log("targetDataAfter===", targetDataAfter)


            const delegateDataAfter = await delegateCallTest.data()
            console.log("delegateDataAfter===", delegateDataAfter)

        });
    });
});
