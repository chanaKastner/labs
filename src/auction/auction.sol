// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "@openzeppelin/ERC721/ERC721.sol";
import "@openzeppelin/ERC20/IERC20.sol";




contract Auction {

  struct auctionSeller {
    address seller;    
    address[] biddersArr;
    mapping(address => uint) bidders;

    bool started = false;
    uint endTime; 

    uint tokenId;
    IERC271 NFT;
    // IERC20  tokenERC20;
    
    address highestBidder;
    uint highestBid;
    }

    error err(string message);

    mapping(uint => auctionSeller) public auctions;

    uint counter = 0;

    constructor(uint _endTime) payable {    
        // emit Start(block.timestamp, endTime, msg.value);
    }

    event Start(uint startTime, uint endTime, uint NFT);
    event Bid(address sender, uint amount);

    receive() external payable {}

    function setEndTime(uint auctionId, uint _endTime) public {
        require(auctions[auctionId].seller == msg.sender); // only seller...
        auctions[auctionId].endTime = _endTime;
    }

    function startAuction(address _NFT, uint _endTime, uint ) {
        

    }
    
    function placesBid() public payable{
        if(block.timestamp > endTime) {
            revert err("This bussiness-requirements ended");
        }
        if(started == false){
            revert err("This bussiness-requirements didn't start yet");
        }
        
        if(msg.value <= 0) {
            revert err("You enter non-valid amount");
        }
        if(address(msg.sender).balance < msg.value) {
            revert err("You don't have enough funds");
        }

        if(msg.value <= highestBid) {
            revert err("The previous bid was higher");
        }

        if(bidders[msg.sender] == 0) {
            bidders[msg.sender] = msg.value;
        }

        else {
            uint amount = msg.value - bidders[msg.sender];
            bidders[msg.sender] += amount;
            payable(address(msg.sender)).transfer(amount);
        }


        highestBid = bidders[msg.sender];
        highestBidder = msg.sender; 

        emit Bid(msg.sender, bidders[msg.sender]);
    }

    function withdraw() public {
        if(bidders[msg.sender] == 0) {
            revert err("You don't exist");
        }
        if(msg.sender.balance == highestBid) {
            revert err("You can't withdraw, yoe are the highest bidder");
        }

        payable(address(this)).transfer(bidders[msg.sender]);
        delete bidders[msg.sender];

    }



    


}