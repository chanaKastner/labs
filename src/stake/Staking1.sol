pragma solidity ^0.8.24;

import "forge-std/console.sol";
import "@openzeppelin/ERC20/IERC20.sol";
import "./MyERC20.sol";
// import "../../lib/solmate/src/tokens/ERC20.sol";

/// @author Chana Kastner
/// @title stake together
contract Staking1 {
    address public owner;
    MyToken public immutable token;
    uint256 public totalReward = 1000000;
    uint256 public totalStaking;
    uint256 WAD = 10 ** 18;
    mapping(address => uint256) public stakers;
    mapping(address => uint256) public dates;

    constructor(address _token) {
        token = MyToken(_token);
        owner = msg.sender;
        totalStaking = 0;
        token.mint(address(this), totalReward);
    }

    function mint(address to, uint256 amount) public {
        token.mint(to, amount);
    }

    receive() external payable {}

    /// @dev Recieve the staked coins and saved the date
    function staking(uint256 amount) public payable {
        require(amount > 0, "you didn't stake enough coins");
        dates[msg.sender] = block.timestamp;
        stakers[msg.sender] += amount;
        console.log("amount!", amount);
        totalStaking += amount;
        console.log("totalStaking:", totalStaking);
        token.transferFrom(msg.sender, address(this), amount);
    }

    /// @dev the staker can pull all his coins with getting his rewards
    function unlockAll() external {
        require(stakers[msg.sender] > 0, "You don't have locked coins");
        require(dates[msg.sender] + 7 days <= block.timestamp, "you aren't entitled to get reward");
        uint256 reward = stakers[msg.sender] / totalStaking * totalReward;
        token.mint(address(this), reward);
        token.transfer(msg.sender, stakers[msg.sender]);
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
        token.mint(address(this), reward);
        token.transfer(msg.sender, amount);
        totalStaking -= amount;
    }

    /// @dev withdraw
    function withdraw() public {
        require(dates[msg.sender] + 7 days > block.timestamp, "You can earn a reward");
        uint256 amount = stakers[msg.sender];
        token.transfer(msg.sender, amount);
    }
}
