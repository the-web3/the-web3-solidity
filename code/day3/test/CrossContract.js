const {
    time,
    loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("cross contracts though interface", function () {

    async function deployCallCrossContracts() {

        const [owner, otherAccount] = await ethers.getSigners();

        const CrossContractCall = await ethers.getContractFactory("CrossContractCall");
        const crossContractCall = await CrossContractCall.deploy();

        const CrossContractCallOne = await ethers.getContractFactory("CrossContractCallOne");
        const crossContractCallOne = await CrossContractCallOne.deploy(crossContractCall);


        return { crossContractCall,  crossContractCallOne, owner, otherAccount };
    }

    describe("TargetContract and CallLearn test script", function () {
        it("call test for before and after", async function () {
            const { crossContractCall,  crossContractCallOne, owner, otherAccount  } = await loadFixture(deployCallCrossContracts);

            const data = crossContractCallOne.addResult();
            console.log("data==", data)

        });
    });
});
