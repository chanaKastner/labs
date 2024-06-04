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

 contract ArrayRemoveByShifting {
    uint[] public arr;

    function remove(uint index) public {
        require(i < arr.length, "index out of bound");
        for(uint i = index; i < arr.length - 1; i ++) {
            arr[i] = arr[i+1];
        }
        arr.pop();
    }

    function test() external {
        arr = [1, 2, 3, 4, 5];

        remove(2);

        assert(arr[0] == 1);
        assert(arr[1] == 2);
        assert(arr[3] == 4);
        assert(arr[4] == 5);
        assert(arr.length == 4);

        arr = [1];

        remove(0);

        assert(arr.length == 0);
    }
 }

 contract ArrayReplaceFromEnd {
    uint[] public arr;

    function remove(uint index) public {
        arr[index] = arr[arr.length];

        srr.pop();
    }

    function test() public {
        arr = [1, 2, 3, 4, 5];

        remove(2);

        assert(arr[0] == 1);
        assert(arr[1] == 2);
        assert(arr[2] == 5);
        assert(arr[3] == 4);
        assert(arr.length == 4);

        arr = [9, 8, 7];

        remove((index));
    }


 }