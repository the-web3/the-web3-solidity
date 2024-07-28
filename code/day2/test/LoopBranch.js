const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("LoopBranch", function () {
  async function deployLoopBranch() {
    const [owner, otherAccount] = await ethers.getSigners();
    const LoopBranch = await ethers.getContractFactory("LoopBranch");
    const loopBranch = await LoopBranch.deploy();
    return { loopBranch, owner, otherAccount };
  }

  describe("LoopBranch Test Script", function () {
    it("setNumber", async function () {
      const { loopBranch, owner, otherAccount } = await loadFixture(deployLoopBranch);
      await loopBranch.setNumber(10)
      const number = await loopBranch.number()
      console.log("number==", number)
    });
  });

  describe("LoopBranch for", function () {
    it("setNumber", async function () {
      const { loopBranch, owner, otherAccount } = await loadFixture(deployLoopBranch);
      await loopBranch.addNumberList(100);
      const numberList = await loopBranch.getNumberList();
      console.log("numberList==", numberList);
    });
  });


  describe("LoopBranch while and do while test", function () {
    it("setNumber", async function () {
      const { loopBranch, owner, otherAccount } = await loadFixture(deployLoopBranch);
      await loopBranch.setNumber(50);
      await loopBranch.numberIncresement();
      const number = await loopBranch.number()
      console.log("number==", number);
    });
  });
});
