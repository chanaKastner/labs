// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/auction/auction.sol";
import "@openzeppelin/ERC721/IERC721.sol";
import "@hack/myTokens/nft1.sol";

contract AuctionTest is Test {
    Auction auction;
    MyERC721 token;

    function setUp() public {
        token = new MyERC721("MyNFT", "NFT");
        auction = new Auction(address(token));
        token.mint(address(this), 1);
    }
    receive() external payable {}


    function test_startAuction_success() public {
        vm.warp(1648739200);
        console.log(msg.sender);
        console.log(address(auction));
        console.log(msg.sender);
        token.approve(address(auction), 1);
        auction.startAuction(1, 5 days, 50);
        console.log("seller:", auction.getAuction(1).seller);
    }

    function test_startAuction_unsuccess() public {
        vm.warp(1648739200);
        token.approve(address(auction), 1);
        vm.expectRevert("Num days must be bigger than zero");
        auction.startAuction(1, 0, 50);
        auction.startAuction(1, 8 days, 50);
        vm.expectRevert("Auction already exist");
        auction.startAuction(1, 10 days, 50);
        vm.expectRevert("Start amount must be bigger than 0");
        auction.startAuction(2, 5 days, 0);
    }

    function test_placeBid_success() public {
        vm.warp(1648739200);

        token.approve(address(auction), 1);
        auction.startAuction(1, 5 days, 100);

        address bidder = address(1234);
        vm.startPrank(bidder);
        vm.deal(bidder, 1000);

        uint256 auctionBalanceBefore = address(auction).balance;
        console.log("auction balance before", auctionBalanceBefore);
        uint256 balanceBefore = bidder.balance;
        console.log("bidder balance before:", bidder.balance);

        vm.warp(1648739200 + 1 days);

        uint256 val = 200;
        auction.placesBid{value: val}(1);

        console.log("auction balance after:", address(auction).balance);
        console.log("bidder balance after:", bidder.balance);

        assertEq(balanceBefore - val, bidder.balance);
        assertEq(auctionBalanceBefore + val, address(auction).balance);
    }

    function test_placeBid_unsuccess() public {
        vm.warp(1648739200);
        address bidder = address(1234);
        vm.startPrank(bidder);
        vm.deal(bidder, 1000);

        uint256 val = 200;
        vm.expectRevert();
        auction.placesBid{value: val}(1);

        vm.stopPrank();

        token.approve(address(auction), 1);
        auction.startAuction(1, 5 days, 100);

        vm.startPrank(bidder);

        vm.warp(1648739200 + 7 days);
        vm.expectRevert();
        auction.placesBid{value: 150}(1);

        vm.expectRevert();
        auction.placesBid{value: 0}(1);

        vm.expectRevert();
        auction.placesBid{value: 2000}(1);

        vm.expectRevert();
        auction.placesBid{value: 50}(1);
    }

    function test_endAuction() public {
        vm.warp(1648739200);

        token.approve(address(auction), 1);
        auction.startAuction(1, 5 days, 100);

        address bidder = address(1234);
        vm.startPrank(bidder);
        vm.deal(bidder, 1000);
        vm.warp(1648739200 + 1 days);
        auction.placesBid{value: 200}(1);

        uint256 sellerBalanceBefore = auction.getAuction(1).seller.balance;
        uint256 bidderBalanceBefore = bidder.balance;
        uint256 contractBalanceBefore = address(auction).balance;

        uint256 bidderToken = token.balanceOf(bidder);
        console.log("bidderToken", bidderToken);
        console.log("seller Balance Before:", sellerBalanceBefore);
        console.log("bidder Balance Before:", bidderBalanceBefore);
        console.log("contract Balance Before:", contractBalanceBefore);

        vm.warp(1648739200 + 5 days);
        auction.endAuction(1);

        console.log("seller Balance After:", auction.getAuction(1).seller.balance);
        console.log("bidder Balance After:", bidder.balance);
        console.log("contract Balance After:", address(auction).balance);
    }
}
