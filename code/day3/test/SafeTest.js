const {
    time,
    loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("SafeTarget and SafeTest", function () {

    async function deploySafeTest() {

        const [owner, otherAccount] = await ethers.getSigners();

        const SafeTarget = await ethers.getContractFactory("SafeTarget");
        const safeTarget = await SafeTarget.deploy();

        const SafeTest = await ethers.getContractFactory("SafeTest");
        const safeTest = await SafeTest.deploy();


        return { safeTarget,  safeTest, owner, otherAccount };
    }

    describe("SafeTarget and SafeTest test script", function () {
        it("safe call test", async function () {
            const { safeTarget,  safeTest, owner, otherAccount  } = await loadFixture(deploySafeTest);

            await safeTest.safeCallTest(safeTarget, 1000)

            const data = await safeTarget.data()
            console.log("data===", data)

        });
    });
});
