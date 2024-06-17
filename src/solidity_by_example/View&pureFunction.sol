pragma solidity ^0.8.19;

contract ViewAndPure {
    uint public x = 1;

    // view
    //state לא משנה את ה
    function addTox(uint y) public view returns (uint){
        return x + y;
    }
    // pure
    //state לא משנה ולא קורה את ה
    function add(uint a, uint b) public pure returns (uint) {
        return a + b;
    }
}