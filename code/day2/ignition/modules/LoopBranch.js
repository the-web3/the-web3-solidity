const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");


module.exports = buildModule("LoopBranch", (m) => {
  const loopBranch = m.contract("LoopBranch");
  return { loopBranch };
});
