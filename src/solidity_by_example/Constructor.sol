pragma solidity ^0.8.19;

contract X {

}

contract Y {

}
contract B is X {}
contract C is X, Y{}
contract D is X, Y{}
contract E is X, Y {}