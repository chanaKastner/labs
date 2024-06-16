pragma soliddity ^0.8.19;

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
        FixedArrayDeletion.myArray(1);
        FixedArrayDeletion.deleteElement(1);
        FixedArrayDeletion.myArray(1);
        FixedArrayDeletion.getLength();
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
    uint[] public myArray = [1, 2, 3, 4, 5];

    function deleteElement(uint index) public {
        require(index < myArray.length, "Invalid index");
        myArray[index] = myArray[index-1];
        myArray.pop();
    }

    function getLength() public view returns (uint) {
        return myArray.length;
    }
}