// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Structs {
    struct Todo {
        string text;
        bool completed;
    }

    Todo[] public todos;

    function create()
}