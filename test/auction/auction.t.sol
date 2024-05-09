// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/auction/auction.sol";
contract AuctionTest is Test{
    Auction br;

    function setUp() public {
        br = new Auction{ value: 20000} (1648739200);
    }

    function test_placeBid() public {
        address bidder = address(1234);
        vm.startPrank(bidder);
        vm.warp(1648739200 - 3 days);
        vm.deal(bidder, 1000);
        console.log("bidder balance before:", bidder.balance);
        br.placesBid{ value:500 }();
        console.log("bidder balance after:", bidder.balance);
       
    }
}