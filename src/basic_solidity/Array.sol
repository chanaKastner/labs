// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.24;

 contract Array {
    uint[]   public arr1; 
    uint[]   public arr2 = [1, 2, 3];
    uint[10] public arr3;

    function get(uint i) public view returns (uint) {
        return arr1[i];
    }

    function getArr() public view returns (uint[] memory) {
        return arr1;
    }

    function push(int num) public {
        arr1.push(num);
    }

    function pop() public {
        arr1.pop();
    }

    function getLength() public view returns (uint) {
        return arr1.length;
    }

    function remove(uint i) public {
        delete arr1[i];
    }

    function examples() public {
        uint[] memory a = new uint[](5);
    }
 }