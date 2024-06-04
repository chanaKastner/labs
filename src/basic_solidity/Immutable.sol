// SPDX-License-Identifier: MIT

 pragma solidity ^0.8.24;

 contract Immutable {

    address public immutable MY_ADDRESS = 0x176CA4Ed2bCEed0B49F28E1ECe6134C9F3a6daD0;
    uint    public immutable MY_UINT    = 123;

    constructor(uint _myUint) {
        MY_ADDRESS = msg.sender;
        MY_UINT = _myUint;
    } 

 }
