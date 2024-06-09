// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/ERC20/IERC20.sol";
import "@openzeppelin/ERC20/extensions/ERC20Permit.sol";

contract AWeth is ERC20 {
    constructor() ERC20("aWeth", "AW") {}

    function mint(address add, uint256 amount) public {
        _mint(add, amount);
    }
}
