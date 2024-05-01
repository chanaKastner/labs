// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.24;

import "@openzeppelin/ERC20/IERC20.sol";
import "@openzeppelin/ERC20/extensions/ERC20Permit.sol";

contract MyToken is ERC20 {
    constructor() ERC20("MyToken", "MTK") {
     
    }

    function mint(address add, uint amount) public {
        _mint(add , amount);
    }
}