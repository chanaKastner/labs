// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.24;

 contract Gas {
    uint public i = 1;

    function forever() {
        while(true) {
            i += 1;
        }
    }
 }