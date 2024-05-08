// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/ERC20/IERC20.sol";

contract aaa {

    IERC20 public immutable token; 
    address[] public addresses;
    
    // constructor(address[] _addresses, address _token) {
    //     addresses = _addresses;
    //     token = IERC20(_token);
    // }

    function distribute(uint amount) public{
        require(amount > 0, "Amount must be bigger than zero");

        uint numberOfAddresses = addresses.length;
        uint amountPerPerson   = amount / numberOfAddresses;
        
        for(uint i =0; i< numberOfAddresses; i++) {
            token.transferFrom(msg.sender, addresses[i], amountPerPerson);
        }
    }
}