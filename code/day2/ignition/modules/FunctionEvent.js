const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");


module.exports = buildModule("FunctionEvent", (m) => {
    const loopBranch = m.contract("FunctionEvent");
    return { loopBranch };
});
