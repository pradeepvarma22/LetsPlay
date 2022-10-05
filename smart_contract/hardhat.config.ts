import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";

const ALCHEMY_API_KEY_URL: string = process.env.ALCHEMY_API_KEY_URL!;   // goerli TEST NETWORK
const METAMASK_PRIVATE_KEY: string = process.env.METAMASK_PRIVATE_KEY!; 
const ALCHEMY_API_MUMBAI_KEY_URL: string = process.env.ALCHEMY_API_MUMBAI_KEY_URL!;

const config: HardhatUserConfig = {
  networks:{
    goerli: {
      url:ALCHEMY_API_KEY_URL,
      accounts:[METAMASK_PRIVATE_KEY]
    },
    mumbai:{
      url:ALCHEMY_API_MUMBAI_KEY_URL,
      accounts:[METAMASK_PRIVATE_KEY]
    }
  },
  solidity: {
    version: "0.8.17"
  },
  paths: {
    artifacts: "./data/src/artifacts",
    cache: "./data/src/cache"
  },
  typechain: {
    outDir: "./data/src/types"
  },
  etherscan: {
    apiKey: process.env.ETHER_SCAN_API_KEY!
  }

};

export default config;
