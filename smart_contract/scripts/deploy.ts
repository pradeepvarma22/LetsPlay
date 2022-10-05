import hre, { ethers } from "hardhat";

const delay = ms => new Promise(res => setTimeout(res, ms));

const _subscriptionId: any = 3510;

async function main() {

  const contractFact = await ethers.getContractFactory("LetsPlay");
  const contract = await contractFact.deploy(_subscriptionId);

  await contract.deployed();
  console.log(`LetsPlay deployed to Address ${contract.address}`);
  console.log('Sleep For 1 Min');
  await delay(70000);               //1.1666667 minute
  console.log(`Start Verify: yarn hardhat verify --network goerli ${contract.address} --constructor-args arguments.ts `);
  

}



main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
