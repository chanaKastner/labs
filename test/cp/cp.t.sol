pragma solidity ^0.8.19;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/cp/cp.sol";
import "@openzeppelin/ERC20/IERC20.sol";
import "../../../src/myTokens/token1.sol";
import "../../../src/myTokens/token2.sol";

contract CpTest is Test {
    Token1 public token1;
    Token2 public token2;
    CP public cp;

    function setUp() public {
        token1 = new Token1();
        token2 = new Token2();
        cp = new CP(address(token1), address(token2));

        token1.mint(msg.sender, 10000000);
        token1.mint(address(this), 10000000);
        token2.mint(msg.sender, 10000000);
        token2.mint(address(this), 10000000);
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
        vm.startPrank(address(4));
        token1.mint(address(4), 500);
        token1.approve(address(cp), 5);
        cp.swap(address(token1), 5);
        console.log("token1:", token1.balanceOf(address(this)));
        console.log("token2:", token2.balanceOf(address(this)));
        vm.stopPrank();
    }

    function test_addLiquidity1() public {
        uint256 reserve1 = cp.reserve1();
        uint256 reserve2 = cp.reserve2();
        token1.approve(address(cp), 5);
        token2.approve(address(cp), 10);

        console.log("reserve1 before:", reserve1);
        console.log("reserve2 before:", reserve2);

        cp.addLiquidity(5, 10);

        console.log("reserve1 after:", cp.reserve1());
        console.log("reserve2 after:", cp.reserve2());

        uint256 newTotal = cp.sqrt(5 * 10);
        assertEq(newTotal, cp.totalSupply());
        assertEq(reserve1 + 5, cp.reserve1());
        assertEq(reserve2 + 10, cp.reserve2());
    }

    function test_addLiquidity2() public {
        test_addLiquidity1();
        uint256 total = cp.totalSupply();
        uint256 reserve1 = cp.reserve1();
        uint256 reserve2 = cp.reserve2();
        token1.approve(address(cp), 15);
        token2.approve(address(cp), 30);

        uint256 share = cp.addLiquidity(15, 30);

        assertEq((total + share), cp.totalSupply());
        assertEq(reserve1 + 15, cp.reserve1());
        assertEq(reserve2 + 30, cp.reserve2());
    }

    function test_addLiquidity3() public {
        test_addLiquidity2();
        uint256 total = cp.totalSupply();
        uint256 reserve1 = cp.reserve1();
        uint256 reserve2 = cp.reserve2();
        token1.approve(address(cp), 1);
        token2.approve(address(cp), 2);

        uint256 share = cp.addLiquidity(1, 2);

        assertEq((total + share), cp.totalSupply());
        assertEq(reserve1 + 1, cp.reserve1());
        assertEq(reserve2 + 2, cp.reserve2());
    }

    function test_removeLiquidity() public {}
}
