// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Wallet
/// @author Chana Kastner

contract Wallet {
    address public owner;

    mapping(address => bool) public gabaim;

    constructor() {
        owner = msg.sender;
    }

    /// @dev a function that can recieve money that was deposited to my wallet

    receive() external payable {}

    /// @dev Withdraw money from the wallet
    /// @param withdrawAmount - the amount of ETH to withdraw

    function withdraw(uint256 withdrawAmount) public {
        require(gabaim[msg.sender], "WALLET-not-owner");

        require(address(this).balance >= withdrawAmount, "There is not enough Eth to withdraw");

        payable(owner).transfer(withdrawAmount);

        // The wallet balance is updated automatically
    }

    /// @dev View the wallet's balance

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    /// @dev add gabaim to the mapping

    function addGabaim(address gabai) public {
        require(owner == msg.sender, " ");
        gabaim[gabai] = true;
    }
}
