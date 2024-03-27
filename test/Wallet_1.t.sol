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
        address allowedUser = 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496;
        vm.startPrank(allowedUser);  
        uint256 balance = address(wallet).balance;
        // console.log(sender.balance); 
        wallet.withdraw(withdrawAmount);
        assertEq(address(wallet).balance, balance - withdrawAmount);
        vm.stopPrank();
    }
   
    function test_failedwithdraw() public {
        uint256 withdrawAmount = 2;
        address userAddress = vm.addr(12); 
        vm.startPrank(userAddress); 
        uint256 balance = uint256(address(wallet).balance); 
        vm.expectRevert();
        wallet.withdraw(withdrawAmount);
        assertEq(address(wallet).balance, balance);
        vm.stopPrank();
    }

  


        
//האם יש מספיק כסף למשוך
// האם המושך הוא מורשה
// אחרי המשיכה - האם נשאר כמצופה
// האם העברה באמת בוצעה
    
    function test_addGabaim() public {
        wallet.addGabaim(sender);
        // console.log(gabai);
        assertTrue(wallet.gabaim(sender));
    }

    function test_deleteGabai() public {
        wallet.addGabaim(sender);
        wallet.deleteGabai(sender);
        // console.log(address(0));
        assertEq(wallet.gabaim(sender), false);
    }

    function test_changeGabai() public {
        wallet.changeGabai(sender, address(this));
        assertTrue(wallet.gabaim(sender));
        assertEq(wallet.gabaim(address(this)), false);
    }

    
 
}


