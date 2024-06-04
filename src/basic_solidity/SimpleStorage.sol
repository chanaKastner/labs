// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.24;

 contract SimpleStorage {
    uint256 public num;
    function set(uint _num) public {
        num = _num;
    }

    function get() public view returns (uint) {
        return num;
    }
}