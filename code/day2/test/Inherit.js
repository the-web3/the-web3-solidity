const {
    time,
    loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("FunctionEvent", function () {
    async function deployInherit() {
        const [owner, otherAccount] = await ethers.getSigners();
        const Inherit = await ethers.getContractFactory("Inherit");
        const inherit = await Inherit.deploy(100);

        return {inherit, owner, otherAccount };
    }

    describe("Test Inherit Script", function () {
        it("inherit test", async function () {
            const { inherit, functionSelectorItem, owner, otherAccount } = await loadFixture(deployInherit);
            const dataB = await inherit.dataB();
            console.log("dataB====", dataB);
            await inherit.setData(1000, 1000);
            const data = await inherit.getData();
            console.log("data====", data);
        });
    });
});
