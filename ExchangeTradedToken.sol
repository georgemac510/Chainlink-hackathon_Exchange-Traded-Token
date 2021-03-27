pragma solidity  >=0.6.0 <0.9.0;
//SPDX-License-Identifier: MIT

//import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract ExchangeTradedToken is ERC20{

    constructor() public ERC20("ExchangeTradedToken", "EXTT") {
        // what should we do on deploy?
        _mint(msg.sender,10 ether);
    }

}



//Kovan contract address: 0xdfa13fb46c44148211d9a9bbb36919d5093d90a0
