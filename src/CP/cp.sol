// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/ERC20/IERC20.sol";

contract CP {
    IERC20 public immutable token1;
    IERC20 public immutable token2;

    uint public reserve1;
    uint public reserve2;

    uint public totalSupply;

    mapping(address => uint) public balances;

    constructor(address t1, address t2) {
        token1 = IERC20(t1);
        token2 = IERC20(t2);
    }

    function mint(address to, uint amount) private {
        balances[to] += amount;
        totalSupply += amount;
    }

    function burn(address from, uint amount) private {
        balances[from] -= amount;
        totalSupply -= amount;
    }

    function swap(address addIn, uint amountIn) external returns (uint amountOut) {
        require(addIn == address(token1) || addIn == address(token2), "AMM3-invalid-token");
        require(amountIn > 0, "AMM3-zero-amount");

        bool isToken1 = addIn == address(token1);

        (IERC20 tokenIn, IERC20 tokenOut, uint reserveIn, uint reserveOut) = isToken1
        ? (token1, token2, reserve1, reserve2)
        : (token2, token1, reserve2, reserve1);

        tokenIn.transferFrom(msg.sender, address(this), amountIn);

        uint amountInWithFee = (amountIn * 997) / 1000;
        amountOut = (reserveOut * amountInWithFee) / (reserveIn + amountInWithFee);

        tokenOut.transfer(msg.sender, amountOut);

        reserve1 = token1.balanceOf(address(this));
        reserve2 = token2.balanceOf(address(this));
    }

    function addLiquidity(uint amount1, uint amount2) external returns (uint shares) {
    token1.transferFrom(msg.sender, address(this), amount1);
    token2.transferFrom(msg.sender, address(this), amount2);

    if(reserve1 > 0 || reserve2 > 0) {
        require(reserve1 * amount2 == reserve2 *  amount1, "x/y != dx/dy");
    }
    if(totalSupply == 0) {
        shares = sqrt(amount1 * amount2);
    }
    else {
        shares = min((amount1 * totalSupply) / reserve1, (amount2 * totalSupply) / reserve2);
    }

    require(shares > 0, "shares = 0");

    mint(msg.sender, shares);

    reserve1 = token1.balanceOf(address(this));
    reserve2 = token2.balanceOf(address(this));
    }

    function removeLiquidity(uint _shares) external returns (uint amount1, uint amount2) {
        uint bal1 = token1.balanceOf(address(this));
        uint bal2 = token2.balanceOf(address(this));

        amount1 = (_shares * bal1) /totalSupply;
        amount2 = (_shares * bal2) / totalSupply;

        require(amount1 > 0 && amount2 > 0, "amount1 or amount2 = 0");

        burn(msg.sender, _shares);
        reserve1 = bal1 - amount1;
        reserve2 = bal2 - amount2;
        token1.transfer(msg.sender, amount1);
        token2.transfer(msg.sender, amount2);
    }

    function sqrt(uint y) private pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function min(uint x, uint y) private pure returns (uint) {
        return x <= y ? x : y;
    }    
    
}




