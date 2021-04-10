pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract TokenFarm is Ownable{
    string public name = "Exchange Token Farm";
    IERC20 public exchangeToken;
    // token address -> mapping of user address -> amounts
    mapping(address => mapping(address => uint256)) public stakingBalance;
    mapping(address => uint256) public uniqueTokensStaked;
    mapping(address => address) public tokenPriceFeedMapping;
    address[] allowedTokens;
    address[] public stakers;

    constructor(address _exchangeTokenAddress) public {
        exchangeToken = IERC20(_exchangeTokenAddress);
    }

    function stakeToken(uint256 _amount, address token) public {
        require(_amount > 0, "Amount cannot be 0");
        if (tokenIsAllowed(token)) {
            updateUniqueTokensStake(msg.sender, token);
            IERC20(token).transferFrom(msg.sender, address(this), _amount);
            stakingBalance[token][msg.sender] = stakingBalance[token][msg.sender] + _amount;
            if (uniqueTokensStaked[msg.sender] == 1){
                stakers.push(msg.sender);
            }
        }
    }

    function setPriceFeedContract(address token, address priceFeed) public onlyOwner{
        tokenPriceFeedMapping[token] = priceFeed;
    }

    function updateUniqueTokensStake(address user, address token) internal {
        if(stakingBalance[token][user] <= 0){
            uniqueTokensStaked[user] = uniqueTokensStaked[user] + 1;
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

    function unstakeTokens(address token) public {
        uint256 balance = stakingBalance[token][msg.sender];
        require(balance > 0, "Staking balance cannot be 0!");
        IERC20(token).transfer(msg.sender, balance);
        stakingBalance[token][msg.sender] = 0;
        uniqueTokensStaked[msg.sender] = uniqueTokensStaked[msg.sender] - 1;
    }

    function issueTokens() public onlyOwner{
        for( uint256 stakersIndex = 0;
        stakersIndex < stakers.length;
        stakersIndex++){
            address recipient = stakers[stakersIndex];
            exchangeToken.transfer(recipient, getUserTotalValue(recipient));
        }
    }

    function getUserTotalValue(address user) public view returns(uint256){
        uint256 totalValue= 0;
        if (uniqueTokensStaked[user] > 0){
            for(
                uint256 allowedTokensIndex = 0;
                allowedTokensIndex < allowedTokens.length;
                allowedTokensIndex++
            ){
                totalValue = totalValue + getUserStakingBalanceEthValue(
                    user,
                    allowedTokens[allowedTokensIndex]
                );
            }
        }
    }

    function getUserStakingBalanceEthValue(address user, address token) public view returns (uint256){
        if(uniqueTokensStaked[user] <= 0){
            return 0;
        }
        return (stakingBalance[token][user] * getTokenEthPrice(token)) / (10**18);
    }

    function getTokenEthPrice(address token) public view returns(uint256){
        address priceFeedAddress = tokenPriceFeedMapping[token];
        AggregatorV3Interface priceFeed = AggregatorV3Interface (priceFeedAddress);
        (
            uint80 roundID,
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return uint256(price);
    }

}
