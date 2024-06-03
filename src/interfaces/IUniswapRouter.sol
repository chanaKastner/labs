pragma solidity ^0.8.24;
pragma abicoder v2;

import "src/interfaces/ISwapRouter.sol";
interface IUniswapRouter is ISwapRouter {
    function refundETH() external payable;
}