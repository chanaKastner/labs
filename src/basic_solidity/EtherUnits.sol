// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.24;

 contract EtherUnits {
    uint public oneWei = 1 wei;
    bool public isOneWei = (oneWei == 1);

    uint public oneGwei = 1 gwei; 
    bool public isOneGwei = (oneGwei == 1e9);

    uint public oneEth = 1 ether;
    bool public isOneEth = (oneEth == 1e18);
 }