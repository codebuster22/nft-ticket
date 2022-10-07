require("dotenv").config({ path: "./.env" });
require("@nomicfoundation/hardhat-toolbox");
require('hardhat-deploy');

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    mumbai: {
      accounts: [process.env.PK],
      url: `https://rpc-mumbai.maticvigil.com/`,
      saveDeployments: true,
    },
  },
  solidity: "0.8.17",
  etherscan: {
    apiKey: process.env.POLYGONSCAN_KEY,
  },
};
