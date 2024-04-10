pragma solidity ^0.8.24;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract Math1Test is Test {

    function setUp() public {
      
    }


    function test_math1() public view {
       uint WAD = 10**18;
    //    uint RAY = 10**27;

       uint a = 2; 
       uint b = 1000;

       uint c = a * WAD / b;

       console.log(c);
       console.log(c * 7);
       console.log(c / 7);

       uint z = c + (9*WAD);
       uint z1 = (z * c) / WAD;

       console.log(z1);
}

}

