require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.24",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    holesky: {
      url: "https://eth-holesky.g.alchemy.com/v2/xis9zzUnd3ts5uZmF9BipBpeWfcYBNzb",
      accounts: ["f18b433b7f3d67a7458b612852b1ec1b10930b532546e9a7852425969d92ed2b"]
    },
    matic: {
      url: `https://endpoints.omniatech.io/v1/matic/mainnet/public`,
      accounts: ["f18b433b7f3d67a7458b612852b1ec1b10930b532546e9a7852425969d92ed2b"]
    }
  },
  etherscan: {
    apiKey: "HZEZGEPJJDA633N421AYW9NE8JFNZZC7JT",
  },
  sourcify: {
    enabled: true
  }
};
