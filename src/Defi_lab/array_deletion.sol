pragma solidity ^0.8.19;

import "forge-std/Test.sol";

contract contractTest is Test {
    ArrayDeletionBug ArrayDeletionBugContract;
    FixedArrayDeletion FixedArrayDeletionContract;

    function setUp() public {
        ArrayDeletionBugContract = new ArrayDeletionBug();
        FixedArrayDeletionContract = new FixedArrayDeletion();      
    }

    function test_ArrayDeletion() public {
        ArrayDeletionBugContract.myArray(1);
        ArrayDeletionBugContract.deleteElement(1);
        ArrayDeletionBugContract.myArray(1);
        ArrayDeletionBugContract.getLength();
    }

    function test_FixedArrayDeletion() public {
        FixedArrayDeletionContract.arr(1);
        FixedArrayDeletionContract.deleteElement(1);
        FixedArrayDeletionContract.arr(1);
        FixedArrayDeletionContract.getLength();
    }

    receive() external payable {}
}

contract ArrayDeletionBug {
    uint[] public myArray = [1, 2, 3, 4, 5];

    function deleteElement(uint index) external {
        require(index < myArray.length, "Invalid index");
        delete myArray[index];
    }

    function getLength() public view returns (uint) {
        return myArray.length;
    }
}

contract FixedArrayDeletion {
    uint[] public arr = [1, 2, 3, 4, 5];

    function deleteElement(uint index) public {
        require(index < arr.length, "Invalid index");
        arr[index] = arr[index-1];
        arr.pop();
    }

    function getLength() public view returns (uint) {
        return arr.length;
    }
}