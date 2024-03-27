// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/wallet/Wallet_1.sol";

contract Wallet_1Test is Test {
    /// @dev Address of the SimpleStore contract.
    Wallet_1 public wallet;
    address sender;


    /// @dev Setup the testing environment.
    function setUp() public {
        wallet = new Wallet_1();
        payable(address(wallet)).transfer(150);
        sender = msg.sender;
    }

    receive() payable external{}

    function test_getBalance() public {
        assertEq(address(wallet).balance, wallet.getBalance());
    }

  function test_deposit() public {
        uint256 depositAmount = 10;
        uint256 balance = address(wallet).balance;

        payable(address(wallet)).transfer(depositAmount);

        assertEq(address(wallet).balance, balance + depositAmount);
    }
    
    function test_withdraw() public {
        uint256 withdrawAmount = 5;  
        uint256 balance = address(wallet).balance;
        // console.log(sender.balance); 
        wallet.withdraw(withdrawAmount);
        assertEq(address(wallet).balance, balance - withdrawAmount);
    }
   
    function test_withdrawFailed() public {
        uint256 withdrawAmount = 2;
        address userAddress = vm.addr(12); 
        vm.startPrank(userAddress); 
        uint256 balance = uint256(address(wallet).balance); 
        vm.expectRevert();
        wallet.withdraw(withdrawAmount);
        assertEq(address(wallet).balance, balance);
        vm.stopPrank();
    }
    
    function test_addGabaim() public {
        wallet.addGabaim(sender);
        assertTrue(wallet.gabaim(sender));
    }

    function test_deleteGabai() public {
        wallet.addGabaim(sender);
        wallet.deleteGabai(sender);
        assertEq(wallet.gabaim(sender), false);
    }

    function test_changeGabai() public {
        wallet.changeGabai(sender, address(this));
        assertTrue(wallet.gabaim(sender));
        assertEq(wallet.gabaim(address(this)), false);
    }

    
 
}


