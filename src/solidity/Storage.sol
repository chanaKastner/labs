// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/// @title storage
/// @dev Store & retrieve value in a variable

contract Storage {
    uint256 number;

    /// @dev Store value in variable
    /// @param num value to store

    function store(uint256 num) public {
        // storing the number we got in to number
        number = num;
    }

    /// @dev Return value
    /// @return value of 'number'

    // what doew view mean?
    function retrieve() public view returns (uint256) {
        return number;
    }
}
