pragma solidity ^0.8.24;

import "@openzeppelin/ERC20/IERC20.sol";

contract Amm {
    address public owner;
    // uint total;
    uint256 public balanceABefore;
    uint256 public balanceBBefore;
    uint256 public balanceAAfter;
    uint256 public balanceBAfter;
    uint256 constant WAD = 10 ** 18;
    uint256 public sqrtK;
    bool public initialized;
    IERC20 public immutable a;
    IERC20 public immutable b;
    mapping(address => uint256) users;

    constructor(address _a, address _b) {
        owner = msg.sender;
        a = IERC20(_a);
        b = IERC20(_b);
    }

    event Swapped(address indexed from, uint256 amountA, uint256 amountB);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function initialize(uint256 initialA, uint256 initialB) external onlyOwner {
        require(!initialized, "Initialization can only be called once");
        require(initialA > 0 && initialB > 0, "Both initialA and initialB must be greater than 0");

        balanceABefore = initialA;
        balanceBBefore = initialB;

        require(a.transferFrom(msg.sender, address(this), initialA), "Transfer failed");
        require(b.transferFrom(msg.sender, address(this), initialB), "Transfer failed");

        initialized = true;

        sqrtK = WAD * sqrt(balanceABefore * balanceBBefore);
    }

    function sqrt(uint256 x) public pure returns (uint256 y) {
        if (x == 0) return 0;
        if (x <= 3) return 1;

        uint256 z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }

    function price(IERC20 token) public view returns (uint256) {
        return sqrtK / token.balanceOf(address(this));
    }

    function tradeAtoB(uint256 amountA) public {
        require(amountA > 0, "Amount most be bigger than zero");
        require(a.balanceOf(msg.sender) >= amountA, "You don't have enough money for the trading");

        balanceABefore = a.balanceOf(address(this));
        balanceBBefore = b.balanceOf(address(this));

        require(a.transferFrom(msg.sender, address(this), amountA), "transfer failed");

        balanceAAfter = balanceABefore + amountA;
        balanceBAfter = (WAD * balanceABefore * balanceBBefore) / balanceAAfter;

        uint256 amountB = balanceBBefore - balanceBAfter;

        require(b.transfer(msg.sender, amountB), "Transfer failed");

        emit Swapped(msg.sender, amountA, amountB);
    }

    function tradeBtoA(uint256 amountB) public {
        require(amountB > 0, "Amount must be bigger than zero");
        require(b.balanceOf(msg.sender) >= amountB, "You don't have enough money for the trading");

        balanceABefore = a.balanceOf(address(this));
        balanceBBefore = b.balanceOf(address(this));

        require(b.transferFrom(msg.sender, address(this), amountB), "Transfer failed");

        balanceBAfter = balanceBBefore + amountB;
        balanceAAfter = (WAD * balanceABefore * balanceBBefore) / balanceBAfter;

        uint256 amountA = balanceABefore - balanceAAfter;

        require(a.transfer(msg.sender, amountA), "Transfer failed");

        emit Swapped(msg.sender, amountB, amountA);
    }

    function addLiquidity(uint256 value) public {
        require(value > 0, "Value must be bigger than zero");
        require(a.balanceOf(msg.sender) * price(a) >= value, "you don't have enough tokens");
        require(b.balanceOf(msg.sender) * price(b) >= value, "you don't have enough tokens");

        uint256 amountA = value / price(a); //amount of coins a
        uint256 amountB = value / price(b); //amount of coins b

        users[msg.sender] += value;

        require(a.transferFrom(msg.sender, address(this), amountA), "Transfer failed");
        require(b.transferFrom(msg.sender, address(this), amountB), "Transfer failed");

        sqrtK = WAD * sqrt(a.balanceOf(address(this)) * b.balanceOf(address(this)));
    }

    // function removeLiquidity(uint value) public {
    //     // require(a.balanceOf(msg.sender) * price() >= value);
    //     // require(b.balanceOf(msg.sender) * price() >= value);
    //      sqrtK = WAD * sqrt(balanceABefore * balanceBBefore);
    // }
}
