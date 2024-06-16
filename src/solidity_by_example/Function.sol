pragma solidity ^0.8.19;

contract Function {

    function returnMany() public pure returns (uint, bool, uint) {
        return(2, false, 5);
    }

    function named() public pure returns (uint x, bool b, uint y) {
        return(4, true, 9);
    }

    function assigned() public pure returns (uint x, bool b, uint y) {
        x = 1;
        b = true;
        y = 2;
    }

    function destructuringAssugnments() public pure returns (uint, bool, uint, uint, uint) {
        (uint a, bool b, uint c) = returnMany();
        (uint d, uint e, uint f) = (1, 2, 3);

        return(a, b, c, d, e);
    }

    function arrayInput(uint[] memory _arr) {}

    uint[] public arr;
    function arrayOutput() public view returns (uint[] memory) {
        return arr;
    } 
}

contract XYZ {
    function someFuncWithManyInputs(uint )
}