// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
//import "forge-std/Test.sol";
//import "forge-std/console.sol";
import "../src/BeitHaknesset.sol";

contract BeitHaknessetTest is Test {
    /// @dev Address of the SimpleStore contract.
    BeitHaknesset public bh;

    /// @dev Setup the testing environment.
    function setUp() public {
        bh = new BeitHaknesset();
    }

    function test_withdraw() public {
        
    }

    function withdraw(uint256 withdrawAmount) public onlyOwner {
        require(gabaim[msg.sender], "Only the owner & the gabaim can withdraw");

        require(
            address(this).balance >= withdrawAmount,
            "There is not enough Eth to withdraw"
        );

        payable(owner).transfer(withdrawAmount);

    }
    /// @dev Ensure that you can set and get the value.
    function testWithdrawFunction(uint256 value) public {
        bh.
        s.setValue(value);
        console.log(value);
        console.log(s.getValue());
        assertEq(value, s.getValue());
    }
}
