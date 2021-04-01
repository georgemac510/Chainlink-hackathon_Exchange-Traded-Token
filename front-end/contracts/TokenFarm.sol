pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenFarm id Ownable{
    string public name = "Exchange Token Farm";
    IERC20 public exchangeToken;
    mapping(address => mapping(address => uint256)) public stakingBalance;
    address[] allowedTokens;

    constructor(address _exchangeTokenAddress) public {
        exchangeToken = IERC20(_exchangeTokenAddress);
    }

    function stakeToken(uint256 _amount, address token) public {
        require(_amount > 0, "Amount cannot be 0");
        if (tokenIsAllowed(token)) {
            updateUniqueTokensStake()
            IERC(token).transferFrom(msg.sender, address(this), _amount);
            stakingBalance
        }
    }

    function tokenIsAllowed(address token) public returns(bool) {
        for ( uint256 allowedTokensIndex = 0; allowedTokensIndex < allowedTokens.length; allowedTokensIndex++) {
            if (allowedTokens[allowedTokensIndex] == token){
                return true;
            }
        }
        return false;
    }

    function addAllowedTokens(address token) public onlyOwner {
        allowedTokens.push(token);
    }

    function unstakeToken() public {

    }

    function issueTokens() public {

    }

    function getTokenEthPrice() public {

    }
}
