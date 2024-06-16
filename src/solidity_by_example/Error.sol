pragma solidity ^0.8.19;

contract Error {
    // Require should be used to validate conditions such as: *inputs *conditions before execution *return values from calls to other functions
    function testRequire(uint x) public pure {
        require(x > 10, "Input must be bigger than 10")
    }
    // Revert is useful when the condition to check is complex. 
    function testRevert(uint x) public pure {
        if (x <= 10) {
            revert("Input must be greater than 10");
        }
    }

    // Assert should only be used to test for internal errors, and to check invariants.
    // Here we assert that num is always equal to 0 since it is impossible to update the value of num
    uint public num;

    function testAssert() public view {
        assert(num == 0);
    }

    // custom error

    error InsufficientBalance(uint balance, uint withdrawAmount); // איזון לא מספיק

    function testCustomError(uint _withdrawAmount) public view {
        uint _balance = address(this).balance;
        if(_balance <= withdrawAmount) {
            revert InsufficientBalance({balance: _balance, withdrawAmount: _withdrawAmount});
        }
    }
}