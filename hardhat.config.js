require("dotenv").config({ path: "./.env" });
require("@nomicfoundation/hardhat-toolbox");
require('hardhat-deploy');

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    goerli: {
      accounts: [process.env.PK],
      url: `https://goerli.infura.io/v3/${process.env.INFURA_KEY}`,
      saveDeployments: true,
    },
  },
  solidity: "0.8.17",
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};
