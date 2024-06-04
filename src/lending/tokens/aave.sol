// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/ERC20/IERC20.sol";
import "@openzeppelin/ERC20/extensions/ERC20Permit.sol";

contract Aave is ERC20 {
    constructor() ERC20("Aave", "AP") {}

    function mint(address add, uint256 amount) public {
        _mint(add, amount);
    }
}
