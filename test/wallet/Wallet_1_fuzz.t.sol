// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/wallet/Wallet_1.sol";


contract Wallet_1FuzzTest is Test {

    Wallet_1 public wallet;  

    function setUp() public {
        wallet = new Wallet_1();
        payable(address(wallet)).transfer(150);
    }

    receive() payable external{}
    function test_fuzz_getBalance() public{
     assertEq(address(wallet).balance, wallet.getBalance());
}
  function test_fuzz_withdraw(uint256 amount) public{
    vm.assume(amount <= address(wallet).balance);
    uint256 balance1=address(this).balance;
    uint256 balance2=address(wallet).balance;
    wallet.withdraw(amount);
    assertEq(address(this).balance , (balance1 + amount));
    assertEq(address(wallet).balance , (balance2 - amount));
}
    function test_fuzz_withdrawFailed(uint256 withdrawAmount) public {
        vm.assume(withdrawAmount <= address(wallet).balance);
        address userAddress = vm.addr(12); 
        vm.startPrank(userAddress); 
        uint256 balance = uint256(address(wallet).balance); 
        vm.expectRevert();
        wallet.withdraw(withdrawAmount);
        assertEq(address(wallet).balance, balance);
        vm.stopPrank();
    }
  function test_fuzz_addGabaim(address gabai) public{
    wallet.addGabaim(gabai);
    assertEq(wallet.gabaim(gabai) , true);
}

function test_fuzz_deleteGabai(address gabai) public{
    vm.expectRevert("Gabai does not exist");
    wallet.deleteGabai(gabai);
    assertEq(wallet.gabaim(gabai) , false);
}

function test_fuzz_changeGabai(address gabai) public{
    wallet.changeGabai(gabai,address(this));
    assertTrue(wallet.gabaim(gabai));
    assertEq(wallet.gabaim(address(this)) , false);
}

}