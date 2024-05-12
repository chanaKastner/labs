// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/ERC20/IERC20.sol";
import "@openzeppelin/ERC20/extensions/ERC20Permit.sol";

contract Token2 is ERC20 {
    constructor() ERC20("Token2", "T2") {
     
    }

    function mint(address add, uint amount) public {
        _mint(add , amount);
    }
}