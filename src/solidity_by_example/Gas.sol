// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.19;

 contract Gas {
    uint public i = 1;

    function forever() public{
        while(true) {
            i += 1;
        }
    }
 }