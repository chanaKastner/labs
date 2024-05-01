pragma solidity ^0.8.24;
import "forge-std/console.sol";

import "../../lib/solmate/src/tokens/ERC20.sol";

/// @author Chana Kastner
/// @title stake together
contract Staking1 is ERC20 {
    address public owner;
    uint256 public totalReward = 1000000;
    uint256 public totalStaking;
    uint256 public beginDate;
    mapping(address => uint256) public stakers;
    mapping(address => uint256) public dates;

    constructor() ERC20("MyToken", "MTK", 16) {
        _mint(address(this), totalReward);
        owner = msg.sender;
        totalStaking = 0;
    }
    receive() external payable {}

    function mint(address add, uint amount) public {
        _mint(add, amount);
    }

    /// @dev Recieve the staked coins and saved the date
    function staking(uint256 amount) public payable {
        require(amount > 0, "you didn't stake enough coins");
        dates[msg.sender] = block.timestamp;
        stakers[msg.sender] += amount;
        console.log("amount!", amount);
        totalStaking += amount;
        console.log("totalStaking:", totalStaking);
        transferFrom(msg.sender, address(this), amount);
    }

    /// @dev the staker can pull all his coins with getting his rewards
    function unlockAll() external {
        require(stakers[msg.sender] > 0, "You don't have locked coins");
        require(dates[msg.sender] + 7 days <= block.timestamp, "you aren't entitled to get reward");
        uint256 reward = stakers[msg.sender] / totalStaking * totalReward;
        _mint(address(this), reward);
        transfer(msg.sender, stakers[msg.sender]);
        totalStaking -= stakers[msg.sender];
        delete stakers[msg.sender];
        delete dates[msg.sender];
    }

    /// @dev The staker can unlock some of his coins and getting a reward accordingly
    function unlock(uint256 amount) external {
        require(stakers[msg.sender] > 0, "You don't have locked coins");
        require(stakers[msg.sender] > amount, "You don't have enough locked coins");
        // require(dates[msg.sender] + 7 days <= block.timestamp, "you aren't entitled to get reward");
        uint256 reward = amount / totalStaking * totalReward;
        _mint(address(this), reward);
        transfer(msg.sender, amount);
        totalStaking -= amount;
    }

    /// @dev withdraw
    function withdraw() public {
        require(dates[msg.sender] + 7 days > block.timestamp, "You can earn a reward");
        uint256 amount = stakers[msg.sender];
        transfer(msg.sender, amount);
    }
}
