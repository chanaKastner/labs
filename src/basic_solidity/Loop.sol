// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.24;

 contract Loop {
    function loop() public {
        // for loop
        for(uint i = 0; i< 10; i++) {
            if(i == 5) {
                continue;
            }
            if (i == 3) {
                break;
            }
        }

        //while loop
        uint j; 
        while (j < 10) {
            j++;
        }
    }

 }