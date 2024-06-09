pragma solidity ^0.8.19;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract Math1Test is Test {
    function setUp() public {}

    function test_math1() public view {
        uint256 WAD = 10 ** 18;
        // uint RAY = 10**27;

        uint256 a = 2;
        uint256 b = 1000;

        uint256 c = a * WAD / b;

        console.log(c);
        console.log(c * 7);
        console.log(c / 7);

        uint256 z = c + (9 * WAD);
        uint256 z1 = (z * c) / WAD;

        console.log(z1);
    }
}
