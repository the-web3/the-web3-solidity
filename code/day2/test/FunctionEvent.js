const {
    time,
    loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("FunctionEvent", function () {
    async function deployFunctionEvent() {
        const [owner, otherAccount] = await ethers.getSigners();
        const FunctionEvent = await ethers.getContractFactory("FunctionEventInherit");
        const functionEvent = await FunctionEvent.deploy();
        return { functionEvent, owner, otherAccount };
    }

    describe("LoopBranch Test Script", function () {
        it("setNumber", async function () {
            const { functionEvent, owner, otherAccount } = await loadFixture(deployFunctionEvent);
            await functionEvent.setData(1000)
            const data = await functionEvent.getValue()
            console.log("data==", data)
        });
    });

    describe("LoopBranch Foo Data", function () {
        it("setNumber", async function () {
            const { functionEvent, owner, otherAccount } = await loadFixture(deployFunctionEvent);
            const data =  await functionEvent["foo(string)"]("The Web3 社区，github: https://github.com/the-web3, websit: https://thewebthree.xyz/;如果你要报名学习我们课程，请加微信：17720087838")
            console.log("data==", data)
            const data1 =  await functionEvent["foo(uint256)"](3000)
            console.log("data1==", data1)
        });
    });

});
