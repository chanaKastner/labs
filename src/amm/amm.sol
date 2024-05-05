pragma solidity ^0.8.24;

import "@openzeppelin/ERC20/IERC20.sol";


contract Amm {
    address public owner;
    uint public balanceA;
    uint public balanceB;
    uint total;
    bool public initialized;
    IERC20 public immutable a;
    IERC20 public immutable b;
    mapping(address => uint)

    constructor(address _a, address _b) {
        owner = msg.sender;
        a = IERC20(_a);
        b = IERC20(_b);
    }


    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function initialize(uint initialA, uint initialB) external onlyOwner  {
        require(!initialized, "Initialization can only be called once");
        require(initialA > 0 && initialB > 0, "Both initialA and initialB must be greater than 0");
        balanceA = initialA;
        balanceB = initialB;
        initialized = true;

    }

    function price() public {
        

    }

    function tradeAtoB() public {

    }

    function tradeBtoA() public {

    }
    function addLiquidity() public {

    }

    function 
    
    
    
    () public {

    }

}