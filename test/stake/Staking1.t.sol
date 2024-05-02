pragma solidity ^0.8.24;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/stake/Staking1.sol";
import "../../../src/stake/MyERC20.sol";

contract staking1Test is Test {
    Staking1 public stake;
    MyToken public token;

   function setUp() public {
        token = new MyToken();
        stake = new Staking1(address(token));  
        stake.mint(address(this), 600000);

        // stake.mint(address(stake), stake.totalReward());
    }
    function test_staking() public {
        // uint totalReward  = stake.totalReward();
        uint totalStaking = stake.totalStaking();
        uint amount       = 1;
        uint stakerAmount = stake.stakers(address(this));
       
        vm.warp(1648739200);

        token.approve(address(this), amount);
        stake.staking(1);
        console.log("date:", stake.dates(address(this)));
        console.log("today:", block.timestamp);

        assertEq(stake.totalStaking(), totalStaking + amount);
        assertEq(stake.stakers(address(this)), stakerAmount + amount);
        assertEq(stake.dates(address(this)), 1648739200);
    }

    function test_unlockAll() public {
        token.approve(address(this), 10000000000);
        vm.warp(1648739200);

        stake.staking(5000);
        vm.warp(1648739200 + 9 days);

        stake.unlockAll();

    }

    function test_unlock() public {
        uint amount = 1000;

        vm.warp(1648739200);

        token.approve(address(this), 100000000);
        stake.staking(3000);

        vm.warp(1648739200 + 8 days);
        console.log("date:", 1648739200 + 9 days);
        stake.unlock(amount);                                                                       


    }

    function test_withdraw() public {
        
    }



}