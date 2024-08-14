const {
    time,
    loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("FunctionEvent", function () {
    async function deployfunctionSelector() {
        const [owner, otherAccount] = await ethers.getSigners();
        const FunctionSelector = await ethers.getContractFactory("FunctionSelector");
        const functionSelector = await FunctionSelector.deploy();

        const FunctionSelectorItem = await ethers.getContractFactory("FunctionSelectorItem");
        const functionSelectorItem = await FunctionSelectorItem.deploy(functionSelector);

        return { functionSelector, functionSelectorItem, owner, otherAccount };
    }

    describe("LoopBranch Test Script", function () {
        it("setNumber", async function () {
            const { functionSelector, functionSelectorItem, owner, otherAccount } = await loadFixture(deployfunctionSelector);
            const selector = await functionSelectorItem.getSetValueSelector()
            console.log(selector);
        });
    });
});
