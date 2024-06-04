pragma solidity ^0.8.24;

import "@openzeppelin/ERC20/IERC20.sol";
import "@openzeppelin/ERC20/ERC20.sol"; 
import "src/lending/math.sol";
import "forge-std/console.sol";
import "../../lib/chainlink/contracts/src/v0.8/l2ep/dev/arbitrum/ArbitrumSequencerUptimeFeed.sol";
import "../../lib/chainlink/contracts/src/v0.8/interfaces/FeedRegistryInterface.sol";
// import "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
// import "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../../lib/openzeppelin-contracts/contracts/utils/math/Math.sol";
// import "../math/Math.sol";
// import "../interfaces/IUniswapRouter.sol";
// import "../interfaces/IWETHGateway.sol";
// import "../interfaces/ILendingPool.sol";

contract Lending is lendingMath {

    uint public totalBorrowed;   // סך הלוואות
    uint public totalReserve;    // 
    uint public totalDeposit;    // סך ההפקדות
    uint public totalCollateral; // סך הבטחונות
    uint public maxLTV = 4;      // 1 = 20%
    uint baseRate = 20000000000000000;
    uint borrowRate = 300000000000000000;

    address public owner;

    mapping(address => uint) public usersCollateral;
    mapping(address => uint) public usersBorrowed;

    IERC20 public dai;
    IERC20 public aDai;
    IERC20 public aWeth;
    IERC20 private weth;

    uint constant ETHPrice = 2900;

    ArbitrumSequencerUptimeFeed internal priceFeed;



    constructor(address daiToken) ERC20("bond", "BND") {
        dai = IERC20(daiToken);
        priceFeed =
        ArbitrumSequencerUptimeFeed(0x9326BFA02ADD2366b30bacB125260Af641031331);

    }
    receive() external payable {}

    modifier onlyOwner() {
        require(msg.sender == owner, "not authorized");
        _;
    }



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
        require(usersCollateral[msg.sender] > 0, "You don't have any collaterals");

        uint borrowed    = usersBorrowed[msg.sender];
        uint collaterals = usersCollateral[msg.sender];

        uint left = mulExp(collaterals, ETHPrice) - borrowed;
        uint toRemove = mulExp(amount, ETHPrice);

        require(toRemove < left, "You don't have enough collaterals");

        usersCollateral[msg.sender] -= amount;
        totalCollateral -= amount;

        payable(msg.sender).transfer(amount);        
    }

    function borrowDai(uint amount) external {
        require(usersCollateral[msg.sender] > 0, "You don't have any collaterals");

        uint borrowed    = usersBorrowed[msg.sender];
        uint collaterals = usersCollateral[msg.sender];

    }

    function repay(uint amount) external {
        require(usersBorrowed[msg.sender] > 0, "You don't have any dep");
        uint ratio = getExp(totalBorrowed , totalDeposit);
        uint interestMul = getExp(borrowRate - baseRate, ratio);
        uint rate = (ratio * interestMul) +baseRate;
        uint fee = amount * rate;
        uint paid = amount - fee;

        totalReserve += fee;
        usersBorrowed[msg.sender] -= paid;
        totalBorrowed -= paid; 
    }

    function liquidation() external onlyOwner() {


    }



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
    function getLatestPrice() public view returns (int256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return price * 10**10;
    }


}