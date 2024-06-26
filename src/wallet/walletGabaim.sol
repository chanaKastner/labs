// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/console.sol";

/// @title Wallet1
/// @author Chana Kastner;

contract Wallet_1 {
    address public owner;

    mapping(address => bool) public gabaim;

    uint256 public gabaimCount;

    uint256 constant MAX_GABAIM = 3;

    constructor() {
        owner = msg.sender;
        console.log("sender", msg.sender);
        gabaim[msg.sender] = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    /// @dev a function that can recieve money that was deposited to my wallet

    receive() external payable {}

    /// @dev Withdraw money from the wallet
    /// @param withdrawAmount - the amount of ETH to withdraw

    function withdraw(uint256 withdrawAmount) public {
        require(gabaim[msg.sender], "Only the owner & the gabaim can withdraw");

        require(address(this).balance >= withdrawAmount, "There is not enough Eth to withdraw");

        payable(msg.sender).transfer(withdrawAmount);
    }

    /// @dev View the wallet's balance

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    /// @dev add gabaim to the mapping
    /// @param gabai - the gabai i want to add

    function addGabaim(address gabai) public onlyOwner {
        // require(gabaim[gabai] == false, "Gabai already exists");
        require(gabaimCount < MAX_GABAIM, "Maximum gabaim reached");
        gabaim[gabai] = true;
        gabaimCount++;
    }

    /// @dev delete gabai
    /// @param gabai - the gabai i want to delete

    function deleteGabai(address gabai) public onlyOwner {
        // require(gabai!=owner, "Be careful! You try to remove yourself");
        require(gabaim[gabai] == true, "Gabai does not exist");
        delete gabaim[gabai];
        gabaimCount--;
    }

    /// @dev change gabai
    /// @param newGabai - the gabai i want to add
    /// @param oldGabai - the gabai i want to delete

    function changeGabai(address newGabai, address oldGabai) public onlyOwner {
        // require(newGabai!=oldGabai,"")
        addGabaim(newGabai);
        deleteGabai(oldGabai);
    }
}
