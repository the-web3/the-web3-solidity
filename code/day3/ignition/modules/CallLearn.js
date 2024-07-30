const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");


module.exports = buildModule("CallLearn", (m) => {

  const targetContract = m.contract("TargetContract");

  const callLearn = m.contract("CallLearn");


  return { targetContract,  callLearn};
});
