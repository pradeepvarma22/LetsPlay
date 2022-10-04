import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { loadFixture, time } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";

const MAX_NO_OF_PLAYERS_PER_GAME: any = 2;


describe("LetsPlay -_-", function () {

  async function deployLetsPlayFixture() {

    const [owner, otherAccount] = await ethers.getSigners();

    const contractFactory = await ethers.getContractFactory("LetsPlay");
    const contract = await contractFactory.deploy();

    return { contract, owner, otherAccount };
  }

  describe("Deployment", function () {

    it("Max No of Players", async function () {
      const { contract, owner, otherAccount } = await loadFixture(deployLetsPlayFixture);

      const _maxPlayers = await contract.maxPlayers();

      expect(_maxPlayers).to.equal(MAX_NO_OF_PLAYERS_PER_GAME);
    });

  });



});
