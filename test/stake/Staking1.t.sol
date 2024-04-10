pragma solidity ^0.8.24;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/stake/Staking1.sol";


contract staking1Test is Test {
    Staking1 public stake;

   function setUp() public {
        stake = new Staking1();  
        // stake.mint(address(stake), stake.totalReward());
    }
    function test_staking() public {
        console.log("total staking:", stake.totalStaking());
        console.log("total reward:", stake.totalReward());
        console.log("balance:", stake.balanceOf(address(stake)));

        uint tr     = stake.totalReward();
        uint ts     = stake.totalStaking();
        uint amount = 1;
        // uint staker = stake.stakers[msg.sender]; 
        // stake.mint(address(this), 600000000000);
        console.log("amount:", amount);
        console.log(stake.balanceOf(msg.sender));

        // vm.deal(msg.sender,amount);
        stake.mint(address(this), 100000000000000000000000000000000000);

        stake.staking(1);
        console.log("total s:", stake.totalStaking());
        

        // assertEq(stake.totalStaking(), ts + amount);
        // assertEq(stake.stakers[msg.sender], staker + amount);
        // assertEq(stake.totalReward(), tr + amount);

    }

    function test_unlockAll() public {

    }

    function test_unlock() public {

    }

    function test_withdraw() public {
        
    }



}