const {
    time,
    loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("TargetContract and CallLearn", function () {

    async function deployMultiCallLearn() {

        const [owner, otherAccount] = await ethers.getSigners();

        const MultiCall = await ethers.getContractFactory("MultiCall");
        const multiCall = await MultiCall.deploy();

        const ContractA = await ethers.getContractFactory("ContractA");
        const contractA = await ContractA.deploy();

        const ContractB = await ethers.getContractFactory("ContractB");
        const contractB = await ContractB.deploy();

        const MultiCallTest = await ethers.getContractFactory("MultiCallTest");
        const multiCallTest = await MultiCallTest.deploy(multiCall);


        return { multiCall,  contractA, contractB, multiCallTest, owner, otherAccount };
    }

    describe("multi call test script", function () {
        it("multi call test", async function () {
            const {multiCall,  contractA, contractB, multiCallTest, owner, otherAccount  } = await loadFixture(deployMultiCallLearn);

            await multiCallTest.setValues(contractA, 100, contractB, 50)


            const dataA = await contractA.getDataA()
            console.log("dataA===", dataA)


            const dataB = await contractB.getDataB()
            console.log("dataB===", dataB)


        });
    });
});
