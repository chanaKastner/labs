// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/ERC721/IERC721.sol";
import "forge-std/console.sol";

contract Auction {
    struct auctionSeller {
        address seller;
        uint256 tokenId;
        bool started;
        uint256 endTime;
        // mapping(address => uint) bidders;
        // address[] biddersArr;
        address highestBidder;
        uint256 highestBid;
    }

    error err(string message);

    mapping(uint256 => auctionSeller) public auctions;
    IERC721 NFT;

    constructor(address NFTaddress) {
        NFT = IERC721(NFTaddress);
    }

    event Start(uint256 startTime, uint256 endTime, uint256 NFT);
    event Bid(address sender, uint256 amount);
    event Withdraw(address bid);
    event End(address winner, uint256 amount);

    receive() external payable {}

    function getAuction(uint256 auctionId) public view returns (auctionSeller memory) {
        return auctions[auctionId];
    }

    function startAuction(uint256 _nftId, uint256 numDays, uint256 startAmount) external {
        // require(msg.sender == auctions[_nftId].seller, "Only seller");
        require(numDays > 0, "Num days must be bigger than zero");
        require(auctions[_nftId].seller == address(0), "Auction already exist");
        require(startAmount > 0, "Start amount must be bigger than 0");

        auctions[_nftId].seller = msg.sender;
        auctions[_nftId].started = true;
        auctions[_nftId].endTime = block.timestamp + numDays;
        auctions[_nftId].highestBid = startAmount;
        console.log("ssssssssssssss");
        NFT.transferFrom(msg.sender, address(this), _nftId);

        emit Start(block.timestamp, auctions[_nftId].endTime, _nftId);
    }

    function placesBid(uint256 _nftId) external payable {
        if (auctions[_nftId].seller == address(0)) {
            revert err("Auction isn't exist");
        }
        if (block.timestamp > auctions[_nftId].endTime) {
            endAuction(_nftId);
        }
        if (auctions[_nftId].started == false) {
            revert err("This auction didn't start yet");
        }
        if (msg.value <= 0) {
            revert err("You enter non-valid amount");
        }
        if (address(msg.sender).balance < msg.value) {
            revert err("You don't have enough funds");
        }

        if (msg.value <= auctions[_nftId].highestBid) {
            revert err("The previous bid was higher");
        }

        // if( auctions[_nftId].bidders[msg.sender] == 0) {
        //      auctions[_nftId].bidders[msg.sender] = msg.value;
        // }

        // else {
        //     uint amount = msg.value -  auctions[_nftId].bidders[msg.sender];
        //     auctions[_nftId].bidders[msg.sender] += amount;
        //     payable(address(msg.sender)).transfer(amount);
        // }

        if (auctions[_nftId].highestBidder != address(0)) {
            payable(address(auctions[_nftId].highestBidder)).transfer(auctions[_nftId].highestBid);
        }

        auctions[_nftId].highestBid = msg.value;
        auctions[_nftId].highestBidder = msg.sender;
        // auctions[_nftId].biddersArr.push(msg.sender);

        emit Bid(msg.sender, auctions[_nftId].highestBid);
    }

    // function withdraw(uint _nftId) public {
    //     if( auctions[_nftId].bidders[msg.sender] == 0) {
    //         revert err("You don't exist");
    //     }
    //     if(msg.sender.balance ==  auctions[_nftId].highestBid) {
    //         revert err("You can't withdraw, you are the highest bidder");
    //     }

    //     //payable(address(this)).transfer( auctions[_nftId].bidders[msg.sender]);
    //     delete  auctions[_nftId].bidders[msg.sender];

    //     emit Withdraw(msg.sender);

    // }

    function endAuction(uint256 _nftId) public {
        require(auctions[_nftId].seller != address(0), "Auction isn't exist");
        require(auctions[_nftId].started == true, "The auction didn't start yet");
        require(auctions[_nftId].endTime <= block.timestamp, "The auction didn't ended yet");

        if (auctions[_nftId].highestBidder == address(0)) {
            NFT.transferFrom(address(this), auctions[_nftId].seller, _nftId);
        } else {
            NFT.transferFrom(address(this), auctions[_nftId].highestBidder, _nftId);
            // for(uint i = 0; i < auctions[_nftId].biddersArr.length; i++){
            //     if(auctions[_nftId].bidders[auctions[_nftId].biddersArr[i]] != 0 &&
            //     auctions[_nftId].bidders[auctions[_nftId].biddersArr[i]] != auctions[_nftId].highestBid)
            //     payable(address(auctions[_nftId].biddersArr[i])).transfer(auctions[_nftId].bidders[auctions[_nftId].biddersArr[i]]);

            //     }
            console.log("address highestBidder:", address(auctions[_nftId].highestBidder));
            payable(address(auctions[_nftId].seller)).transfer(auctions[_nftId].highestBid);
            console.log("@@@@@@@@@@@@@@@");
        }
        delete auctions[_nftId];
    }
}
