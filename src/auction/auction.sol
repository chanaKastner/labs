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
        address highestBidder;
        uint256 highestBid;
    }

    error err(string message);

    mapping(uint256 => auctionSeller) public auctions;
    IERC721 NFT;

    constructor(address NFTaddress) {
        NFT = IERC721(NFTaddress);
    }

    event Start(uint256 indexed startTime, uint256 indexed endTime, uint256 indexed NFT);
    event Bid(address indexed sender, uint256 indexed amount);
    event Withdraw(address indexed bid);
    event End(address indexed winner, uint256 indexed amount);

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
        if (auctions[_nftId].highestBidder != address(0)) {
            payable(address(auctions[_nftId].highestBidder)).transfer(auctions[_nftId].highestBid);
        }

        auctions[_nftId].highestBid = msg.value;
        auctions[_nftId].highestBidder = msg.sender;

        emit Bid(msg.sender, auctions[_nftId].highestBid);
    }

    function endAuction(uint256 _nftId) public {
        require(auctions[_nftId].seller != address(0), "Auction isn't exist");
        require(auctions[_nftId].started == true, "The auction didn't start yet");
        require(auctions[_nftId].endTime <= block.timestamp, "The auction didn't ended yet");

        if (auctions[_nftId].highestBidder == address(0)) {
            NFT.transferFrom(address(this), auctions[_nftId].seller, _nftId);
        } else {
            NFT.transferFrom(address(this), auctions[_nftId].highestBidder, _nftId);

            console.log("address highestBidder:", address(auctions[_nftId].highestBidder));
            console.log("address seller:", address(auctions[_nftId].seller));

            payable(address(auctions[_nftId].seller)).transfer(auctions[_nftId].highestBid);
        }
        emit End(auctions[_nftId].highestBidder, auctions[_nftId].highestBid);
        delete auctions[_nftId];
    }
}
