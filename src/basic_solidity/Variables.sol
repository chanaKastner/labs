// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

contract Variables {
    string public text   = "Hello";
    uint   public number = 123;

    function doSomething() public {
        uint i = 456;
        uint timestamp = block.timestamp;
        address sender = msg.sender;
    }
}