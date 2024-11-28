const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("Base", function () {
  async function deployFunctionCaseInherit() {
    const [owner, otherAccount] = await ethers.getSigners();
    const baseInherit = await ethers.getContractFactory("BaseInherit");
    const baseInheritContract = await baseInherit.deploy(1);
    return { baseInheritContract, owner, otherAccount };
  }

  describe("FunctionCase Test Script", function () {
    it("getInheritStateVar", async function () {
      const { baseInheritContract, owner, otherAccount } = await loadFixture(deployFunctionCaseInherit);
      // await baseInheritContract.updateStateVar(10);
      // const stateVar = await functionCaseContract.getInheritStateVar()
      // console.log("stateVar==", stateVar)
    });
  });
});
