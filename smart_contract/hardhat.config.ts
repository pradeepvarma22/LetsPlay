import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
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
