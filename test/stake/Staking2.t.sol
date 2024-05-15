// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/stake/Staking2.sol";
import "@hack/stake/MyERC20.sol";
contract staking2Test is Test {

    uint constant WAD = 10 ** 18;

    StakingRewards stakingRewards;
    MyToken stakingToken;
    MyToken rewardsToken;
    
//איש מכניס 100 טוקן
// יש 1000 טוקן
// כמה הוא מקבל אחרי יומיים?
    function setUp() public {
        stakingToken = new MyToken();
        rewardsToken = new MyToken();
        stakingRewards = new StakingRewards(address(stakingToken), address(rewardsToken));
        rewardsToken.mint(address(stakingRewards), 100000 * WAD);
    }

    function test_stakingRewards() public {
        // vm.warp(1735689600);
        stakingRewards.updateRate(1000);
        console.log("rate:", stakingRewards.rate());

        address guy = address(123);
        vm.startPrank(guy);
    }
        function test_stake() public {
        // uint256 initialBalance = stakingRewards.stakingToken().balanceOf(address(this));
        // uint256 amountToStake = 100;

        // stakingRewards.stake(amountToStake);

        // uint256 finalBalance = stakingRewards.stakingToken().balanceOf(address(this));
        // assertTrue(finalBalance == initialBalance - amountToStake, "Staking failed");
    }

    function test_withdraw() public {
        // uint256 amountToStake = 100;
        // stakingRewards.stake(amountToStake);

        // uint256 initialBalance = stakingRewards.stakingToken().balanceOf(address(this));

        // stakingRewards.withdraw(amountToStake);

        // uint256 finalBalance = stakingRewards.stakingToken().balanceOf(address(this));
        // assertTrue(finalBalance == initialBalance + amountToStake, "Withdrawal failed");
    }

    function test_getReward() public {
        // uint256 amountToStake = 100;
        // stakingRewards.stake(amountToStake);

        // uint256 initialRewardBalance = stakingRewards.rewardsToken().balanceOf(address(this));
        // stakingRewards.getReward();
        // uint256 finalRewardBalance = stakingRewards.rewardsToken().balanceOf(address(this));

        // assertTrue(finalRewardBalance != initialRewardBalance, "Reward not received");
    }
}