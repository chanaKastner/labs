// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/ERC20/IERC20.sol";
import "@openzeppelin/ERC20/extensions/ERC20Permit.sol";

contract Dai is ERC20 {
    constructor() ERC20("dai", "D") {}

    function mint(address add, uint256 amount) public {
        _mint(add, amount);
    }
}
