pragma solidity  >=0.6.0 <0.9.0;
//SPDX-License-Identifier: MIT

//import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract ExchangeTradedToken is ERC20{

    constructor() public ERC20("ExchangeTradedToken", "EXTT") {
        // what should we do on deploy?
        _mint(msg.sender,1000000 * (10 ** uint256(decimals())));
    }

}



//Kovan contract address: 0xdfa13fb46c44148211d9a9bbb36919d5093d90a0
//deployed 3-27-21 11:11 AM

//new Kovan contract address: 0xd4472baba20e582211970eed601e40329e5337b6
//deployed 3-29-21 11:53 AM
