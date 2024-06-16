pragma solidity ^0.8.19;

import "forge-std/Test.sol";

contract contractTest is Test {

    LotteryGame lg;

    function test_backdoorCall() public {
        address alice = vm.addr(1);
        address bob   = vm.addr(2);

        lg = new LotteryGame();
        // console.log()

        vm.prank(alice);
        lg.pickWinner(address(alice));
        console.log("Prize:", lg.prize());

        lg.pickWinner(address(bob));
        console.log("Admin manipulated winner:", lg.winner());
    }
}

contract LotteryGame {
    uint    public prize = 1000;
    address public winner;
    address public admin = msg.sender;

    modifier safeCheck() {
        if (msg.sender == referee()) {
            _;
        } else {
            getWinner();
        }
    }

    function referee() internal view returns (address user) {
        assembly  {
            user := sload(2)
        }
    }
    function pickWinner(address random) public safeCheck {
        assembly {
            sstore(1, random)
        }
    }

    function getWinner() public view returns (address) {
        console.log("Current winner:", winner);
        return winner;
    }

}
