pragma solidity ^0.8.24;

import "@openzeppelin/ERC20/IERC20.sol";
import "@openzeppelin/ERC20/ERC20.sol";
import "src/lending/math.sol";

contract Lending is ERC20, lendingMath {

    uint public totalBorrowed;  // סך הלוואות
    uint public totalReserve; // 
    uint public totalDeposit; //סך ההפקדות
    uint public totalCollateral; // סך הבטחונות
    uint public maxLTV = 4; // 1 = 20%

    address public owner;

    mapping(address => uint) public usersCollateral;
    mapping(address => uint) public usersBorrowed;

    IERC20 public dai;

    constructor(address daiToken) ERC20("bond", "BND") {
        dai = IERC20(daiToken);
    }
    receive() external payable {}

    function deposit(uint amount) external {
        require(amount > 0, "Amount must be bigger than zero");
        require(dai.balanceOf(msg.sender) >= amount, "You don't have enough dai");

        dai.transferFrom(msg.sender, address(this), amount);
                
        totalDeposit += amount;

        uint bondsToMint = getExp(amount, getExchangeRate());

        _mint(msg.sender, bondsToMint);
    }

    function unbond(uint amount) external {
        require(amount > 0, "Amount must be bigger than zero");
        require(amount <= balanceOf(msg.sender), "You don't have enough bonds");
        
        dai.transferFrom(address(this), msg.sender, amount);
        
        totalDeposit -= amount;

        uint daiToRecieve = mulExp(amount, getExchangeRate());

        _burn(msg.sender, daiToRecieve);

    }

    function addCollateral() payable external {
        require(msg.value > 0, "Value must be bigger than zero");
        usersCollateral[msg.sender] += msg.value;
        totalCollateral += msg.value;
    }
    function removeCollateral(uint amount) external {
        require(amount > 0);
        require(usersCollateral[msg.sender] > amount, "You don't have enough collaterals");

        uint borrowed    = usersBorrowed[msg.sender];
        uint collaterals = usersCollateral[msg.sender];

        uint 


        
    }

////////////

    function getCash() public view returns (uint256) {
        return totalDeposit - totalBorrowed;
    }

    function getExchangeRate() public view returns (uint256) {
        if (totalSupply() == 0) {
            return 1000000000000000000;
        }
        uint256 cash = getCash();
        uint256 num = cash + totalBorrowed + totalReserve;
        return getExp(num, totalSupply());
    }

}