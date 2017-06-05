pragma solidity ^0.4.6;

//Smart contract for the coin that using as reward for likes and shared of content.
//The coin could be converted to ether according to course.

//Extends from ERC 20 standard token https://github.com/ethereum/EIPs/issues/20
import "tokens/contracts/StandardToken.sol";

//Providing coins for likes and reposts
contract LikeCoin is StandardToken {
    //Address of initial owner of all coins
    address public coinsMaster;
    //Ether to LikeCoin exchange course
    uint256 public constant ethToCoinCourse = 10;
    //Multiplier for like
    uint8 public constant likeMultiplier = 1;
    //Multiplier for share
    uint8 public constant shareMultiplier = 2;
    //Hashed of content that can be rewarded for likes and shares and reward multiplier
    mapping (uint256 => uint8) public contentIds;

    event Like(uint256 _contentId, address indexed _whoLiked, uint256 _reward);
    event Share(uint256 _contentId, address indexed _whoLiked, uint256 _reward);

    //Send 100000 tokens to contract creator. Define content hashes.
    function LikeCoin() {
        totalSupply = 100000;
        coinsMaster = tx.origin;
        balances[coinsMaster] = totalSupply;
        approve(coinsMaster, totalSupply);

        //Define ids and multipliers of content will be rewarded
        contentIds[1] = 1;
        contentIds[2] = 1;
        contentIds[3] = 2;
    }

    //Transfer assets for liking of content to specified address
    function like(uint256 _contentId, address _coinsReceiver) returns (bool result) {
        uint256 reward = calculateReward(likeMultiplier, _contentId);
        Like(_contentId, _coinsReceiver, reward);
        return transferFrom(coinsMaster, _coinsReceiver, reward);
    }

    //Transfer assets for sharing of content to specified address
    function share(uint256 _contentId, address _coinsReceiver) returns (bool result) {
        uint256 reward = calculateReward(shareMultiplier, _contentId);
        Share(_contentId, _coinsReceiver, reward);
        return transferFrom(coinsMaster, _coinsReceiver, reward);
    }

    //Sends ether in exchange for LikeCoins
    function transferEtherForCoins(address _ethReceiver, uint256 _coinsValue) {
        if (balanceOf(_ethReceiver) >= _coinsValue) {
            burn(_ethReceiver, _coinsValue);
            _ethReceiver.transfer(convertToEther(_coinsValue));
        }
    }

    //Burn LikeCoins converted to ether
    function burn(address _coinsOwner, uint256 _coinsValue) private {
        totalSupply -= _coinsValue;
        balances[_coinsOwner] -= _coinsValue;
    }

    //Calculates coins reward based on multiplier and content multiplier
    function calculateReward(uint8 _baseMultiplier, uint256 _contentId) private constant returns (uint256 reward) {
        return _baseMultiplier * getContentMultiplier(_contentId);
    }

    //Calculates content multiplier based on content hash
    function getContentMultiplier(uint256 _contentId) private constant returns (uint8 rewardMultiplier) {
        return contentIds[_contentId];
    }

    //Converts assets to ether
    function convertToEther(uint256 _coinsValue) private constant returns (uint256 etherValue) {
        return _coinsValue / ethToCoinCourse;
    }
}
