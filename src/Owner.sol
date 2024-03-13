// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/// @title Owner
/// @dev Set & change owner

contract Owner{

    address private owner;

    //an event for EVM logging
    //what is 'indexed'?

    event OwnerSet(address indexed oldOwner, address indexed newOwner);

    //Checks if the caller is the owner
    //What is 'modifier'?
    //a code that can be reused in a functions in the contract

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

   //Changing owners 
   // and checking that the owner is the one who called the function
   // using the modifier

    function changeOwner(address newOwner) public isOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }

    /// @dev Return owner address
    /// @return address of owner

    //what does external mean?

    function getOwner() external view returns (address) {
        return owner;
    }
}
