// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/Wallet_1.sol";

contract Wallet_1Test is Test {
    /// @dev Address of the SimpleStore contract.
    Wallet_1 public wallet;
    address sender;


    /// @dev Setup the testing environment.
    function setUp() public {
        wallet = new Wallet_1();
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

        payable(address(wallet)).transfer(10);
        
        uint256 balance = address(wallet).balance;

        payable(wallet).withdraw(withdrawAmount);

        assertEq(address(wallet).balance, balance - withdrawAmount);
    }

  


        
//האם יש מספיק כסף למשוך
// האם המושך הוא מורשה
// אחרי המשיכה - האם נשאר כמצופה
// האם העברה באמת בוצעה
    
    function test_addGabaim() public {
        wallet.addGabaim(sender);
        // console.log(gabai);
        assertEq(wallet.gabaim(sender), true);
    }

    function test_deleteGabai() public {
        wallet.addGabaim(sender);
        wallet.deleteGabai(sender);
        // console.log(address(0));
        assertEq(wallet.gabaim(sender), false);
    }

    function test_changeGabai() public {
        wallet.changeGabai(sender, address(this));
        assertEq(wallet.gabaim(sender), true);
        assertEq(wallet.gabaim(address(this)), false);
    }

    
 
}


