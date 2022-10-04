import { ethers } from "hardhat";

async function main() {

  const contractFact = await ethers.getContractFactory("LetsPlay");
  const contract = await contractFact.deploy();

  await contract.deployed();

  console.log(`LetsPlay deployed to Address ${contract.address}`);
}



main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
