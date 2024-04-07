pragma solidity ^0.8.24;

import "../../lib/solmate/src/tokens/ERC20.sol";

/// @author Chana Kastner
/// @title stake together 
contract Stake is ERC20{

    address public owner;
    uint public totalReward = 1000000;
    uint public totalStaking;
    uint public beginDate;
    mapping(address => uint) public stakers;
    mapping(address => uint) public dates;

    constructor() ERC20("MyToken", "MTK", 16){
        _mint(address(this), totalReward * (10 ** uint(16)));
        owner = msg.sender;
        totalStaking = 0;
    }

    receive() external payable {}

    /// @dev Recieve the staked coins and saved the date
    function staking(uint value) external payable {
        require(value > 0, "you didn't stake enough coins");
        dates[msg.sender] = block.timestamp;
        stakers[msg.sender] += value;
        totalStaking += value;
        transferFrom(msg.sender, address(this), value);
    }

    /// @dev the staker can pull all his coins with getting his rewards 
    function unlockAll() external {
        require(stakers[msg.sender] > 0, "You don't have locked coins");
        require(dates[msg.sender] + 7 days <= block.timestamp, "you aren't entitled to get reward");
        uint reward = stakers[msg.sender]/totalStaking*totalReward;
        transfer(msg.sender, reward + stakers[msg.sender]);
        totalStaking -= stakers[msg.sender];
        delete stakers[msg.sender];
        delete dates[msg.sender];
    }

    /// @dev The staker can unlock some of his coins and getting a reward accordingly
        function unlock(uint amount) external {
        require(stakers[msg.sender] > 0, "You don't have locked coins");
        require(stakers[msg.sender] > amount, "You don't have enough locked coins");
        require(dates[msg.sender] + 7 days <= block.timestamp, "you aren't entitled to get reward");
        uint reward = amount/totalStaking*totalReward;
        transfer(msg.sender, reward + amount);
        totalStaking -= amount;
    }

    /// @dev withdraw 
    function withdraw() public {
        require(dates[msg.sender] + 7 days > block.timestamp, "You can earn a reward");
        uint amount = stakers[msg.sender];
        transfer(msg.sender, amount);
    }

    // if the stakers adds coins
    // if the staker wants his coins before 7 days
    // if he wants to take out only some of his coins





}

