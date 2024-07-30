const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("TargetContract and CallLearn", function () {

  async function deployCallLearn() {

    const [owner, otherAccount] = await ethers.getSigners();

    const TargetContract = await ethers.getContractFactory("TargetContract");
    const targetContract = await TargetContract.deploy();

    const CallLearn = await ethers.getContractFactory("CallLearn");
    const callLearn = await CallLearn.deploy();


    return { targetContract,  callLearn, owner, otherAccount };
  }

  describe("TargetContract and CallLearn test script", function () {
    it("call test for before and after", async function () {
      const { targetContract,  callLearn, owner, otherAccount  } = await loadFixture(deployCallLearn);

      console.log("targetContract===", await targetContract.getAddress());
      console.log("owner.address===", owner.address);
      console.log("callLearn===", await callLearn.getAddress());

      const dataBefore = await targetContract.data()

      console.log("dataBefore===", dataBefore)

      await callLearn.callSetData(targetContract, 1000)

      const dataAfer = await targetContract.data()
      console.log("dataAfer===", dataAfer)

    });
  });
});
