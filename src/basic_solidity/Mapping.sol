// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.19;

 contract Mapping {
    mapping(address => uint ) public myMap;

    function get(address add) public view returns (uint) {
        return myMap[add];
    }

    function set(address add, uint num) public {
        myMap[add] = num;
    }

    function remove(address add) public {
        delete myMap[add];
    }
 }

 contract NestedMapping {
    mapping(address => mapping (uint => bool)) public nested;

    function get(address add, uint i) public view returns (bool) {
        return nested[add][i];
    }

    function set(address add, uint i, bool _bool) public {
        nested[add][i] = _bool;    
    }

    function remove(address add, uint i) public {
        delete nested[add][i];
    }
 }