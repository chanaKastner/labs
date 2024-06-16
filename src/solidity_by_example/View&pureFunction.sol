pragma solidity ^0.8.19;

contract ViewAndPure {
    uint public x = 1;

    // pure
    //state לא משנה את ה
    function addTox(uint y) public pure returns (uint){
        return x + y;
    }
    // view
    //state לא משנה ולא קורה את ה
    function add(uint a, uint b) public view returns (uint) {
        return a + b;
    }
}