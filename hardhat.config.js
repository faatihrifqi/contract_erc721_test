require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  networks: {
    rinkeby: {
      url: `${process.env.ALCHEMY_RINKEBY}`,
      accounts: [`${process.env.TEST_ACCOUNT_PRIVATE_KEY}`],
    },
    // mainnet: {
    //   url: `${process.env.ALCHEMY_MAINNET}`,
    //   accounts: [`${process.env.MAIN_ACCOUNT_PRIVATE_KEY}`],
    // },
  },
  etherscan: {
    apiKey: process.env.TEST_ETHERSCAN_API_KEY,
    // apiKey: process.env.MAIN_ETHERSCAN_API_KEY,
  },
};
