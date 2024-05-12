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
        token.mint(address(this),1);
    }

    function test_startAuction_success() public{
        vm.warp(1648739200);
        console.log(msg.sender);
         console.log(address(auction));
         console.log(msg.sender);
        token.approve(address(auction), 1);
        auction.startAuction(1, 5 days);
        console.log("seller:", auction.getAuction(1).seller);
        // console.log("started:", br.auctions[1].started());
        // console.log("endTime:", br.auctions[1].endTime());
     

    }
    // function test_placeBid() public {
    //     vm.warp(1648739200);
    //     auction.startAuction(1, 5 days);
    //     address bidder = address(1234);
    //     vm.startPrank(bidder);
    //     vm.deal(bidder, 1000);
    //     console.log("bidder balance before:", bidder.balance);
    //     vm.warp(1648739200 + 1 days);

    //     // br.placesBid{ value:500 }(1);
    //     console.log("bidder balance after:", bidder.balance);
       
    // }
}