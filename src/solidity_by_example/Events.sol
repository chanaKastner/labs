pragma solidity ^0.8.19;

contract Events {

    event Log(address indexed sender, string message);
    event AnotherLog();

    function test() public {
        emit Log(msg.sender, "Hello!!!!");
        emit Log(msg.sender, "abc");
        emit AnotherLog();
    }
}