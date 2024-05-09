// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/stake/Staking2.sol";
import "@hack/stake/MyERC20.sol";
contract staking2Test is Test {

    StakingRewards sr;
    MyToken stakingToken;
    MyToken rewardsToken;
    
//איש מכניס 100 טוקן
// יש 1000 טוקן
// כמה הוא מקבל אחרי יומיים?
    function setUp() public {
        stakingToken = new MyToken();
        rewardsToken = new MyToken();
        sr = new StakingRewards(address(stakingToken), address(rewardsToken));
    
    }

    function test_stakingRewards() public {
        // vm.warp(1735689600);
        sr.updateRate(1000);
        console.log("rate:", sr.rate());

        address guy = address(123);
        vm.startPrank(guy);




    }
}