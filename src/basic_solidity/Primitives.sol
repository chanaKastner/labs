// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract Primitives {
    bool public boo = true;

    uint8 public u8 = 1;
    uint256 public u256 = 456;
    uint256 public u = 123;

    int8 public i8 = -1;
    int256 public i256 = 456;
    int256 public i = -123;

    int256 public minInt = type(int256).min;
    int256 public maxInt = type(int256).max;

    address public add = 0x176CA4Ed2bCEed0B49F28E1ECe6134C9F3a6daD0;

    bytes1 a = 0xb5;
    bytes1 b = 0x56;

    bool    public defaultBoo;  // false
    uint256 public defaultUint; // 0
    int256  public defaultInt;  // 0
    address public defaultAddr; // 0x00000000000000000000000000000000
}