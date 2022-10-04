// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LetsPlay is ERC20, Ownable {

    uint256 public maxPlayers;


    constructor() ERC20("","") Ownable()
    {
        maxPlayers = 3;
    }



}
