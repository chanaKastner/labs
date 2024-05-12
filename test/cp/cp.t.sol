pragma solidity ^0.8.24;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/CP/cp.sol";
import "@openzeppelin/ERC20/IERC20.sol";
import "../../../src/myTokens/token1.sol";
import "../../../src/myTokens/token2.sol";


contract cpTest is Test {
    Token1 public token1;
    Token2 public token2;
    CP public cp;

  function setUp() public {
    cp = new CP(address(token1), address(token2));

    token1 = new Token1();
    token2 = new Token2();

    token1.mint(msg.sender, 10000000);
    token2.mint(msg.sender, 10000000);
  } 

  // function test_mint() public {
  //   address to = msg.sender;
  //   uint amount = 20;
  //   uint256 balance = cp.balances(to);
  //   uint total = cp.totalSupply();
    
  //   console.log("total before:", total);
  //   console.log("balance before:", cp.balances(to));

  //   cp.mint(to, amount);

  //   console.log("total after:", cp.totalSupply() );
  //   console.log("balance after:", cp.balances(to));

  //   assertEq(balance + amount, cp.balances(to));
  //   assertEq(total + amount, cp.totalSupply());
  // }
  // function test_burn() public {
    
  // }  
  function test_swap() public {
    
    
  }
  function test_addLiquidity() public {
    
  }
  function test_removeLiquidity() public {
    
  }
}