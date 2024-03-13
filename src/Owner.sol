// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/// @title Owner
/// @dev Set & change owner

contract Owner{
    address private owner;

    //event for EVM logging
    event OwnerSet(address indexed oldOwner, address indexed newOwner);

    //Checks if the caller is the owner
    modifier isOwner() {
        //if the first argument is 'false' -
        //The execution will end and all changes to the status and to Ether balances will be returned
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    /// @dev Set contract deployer as owner

    constructor() {
        owner = msg.sender;
        emit OwnerSet(address(0), owner);
    }

    /// @dev Change owner
    /// @param newOwner address of new owner

    function changeOwner(address newOwner) public isOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }

    /// @dev Return owner address
    /// @return address of owner

    function getOwner() external view returns (address) {
        return owner;
    }
}
