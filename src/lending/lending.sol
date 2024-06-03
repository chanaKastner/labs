// pragma solidity ^0.8.24;
// // import "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/ERC20/IERC20.sol";
// import "@openzeppelin/ERC20/ERC20.sol"; 
// import "src/lending/math.sol";
// import "./tokens/aDai.sol";
// import "./tokens/aWeth.sol";
// import "./tokens/weth.sol";
// import "./tokens/dai.sol";
// import "./tokens/bond.sol";
// import "./tokens/aave.sol";

// import "src/interfaces/ILendingPool.sol";
// import "src/interfaces/IWETHGateway.sol";
// import "src/interfaces/IUniswapRouter.sol";

// import "../../lib/chainlink/contracts/src/v0.8/l2ep/dev/arbitrum/ArbitrumSequencerUptimeFeed.sol";


// contract Lending is lendingMath {

//     uint public totalBorrowed;   // סך הלוואות
//     uint public totalReserve;    // 
//     uint public totalDeposit;    // סך ההפקדות
//     uint public totalCollateral; // סך הבטחונות
//     uint public maxLTV = 4;      // 1 = 20%
//     uint baseRate = 20000000000000000;
//     uint borrowRate = 300000000000000000;

//     address public owner;

//     mapping(address => uint) public usersCollateral;
//     mapping(address => uint) public usersBorrowed;

//     IERC20 public dai = IERC20();
//     ADai public aDai = ADai(0xdCf0aF9e59C002FA3AA091a46196b37530FD48a8);
//     AWeth public aWeth = AWeth(0x87b1f4cf9BD63f7BBD3eE1aD04E8F52540349347);
//     Weth private weth = Weth(0xd0A1E359811322d97991E03f863a0C30C2cF029C);
//     Bond public bond = Bond();
//     ILendingPool public aave = ILendingPool(0xE7Ad716aC5c3Fb259A69a8a56a57D5D16598626a); 
//     IWETHGateway public constant wethGateway = IWETHGateway(0xddAb52E62d5a43448CDE0903BB6b6f6904a88959);
//     IUniswapRouter public constant uniswapRouter = IUniswapRouter(0x50443a7Ce0F717f7FF5ddF6B13607269BfDc7e65);
    
//     ArbitrumSequencerUptimeFeed internal priceFeed = ArbitrumSequencerUptimeFeed(0x9326BFA02ADD2366b30bacB125260Af641031331);
//     uint constant ETHPrice = 2900;

//     constructor() {   
//     }
//     receive() external payable {}

//     modifier onlyOwner() {
//         require(msg.sender == owner, "not authorized");
//         _;
//     }

//     function deposit(uint amount) external {
//         require(amount > 0, "Amount must be bigger than zero");
//         require(dai.balanceOf(msg.sender) >= amount, "You don't have enough dai");

//         dai.transferFrom(msg.sender, address(this), amount);        
//         totalDeposit += amount;
//         sendDaiToAave(amount);
//         uint bondsToMint = getExp(amount, getExchangeRate());
//         bond.mint(msg.sender, bondsToMint);
//     }

//     function unbond(uint amount) external {
//         require(amount > 0, "Amount must be bigger than zero");
//         require(amount <= bond.balanceOf(msg.sender), "You don't have enough bonds");
        
//         dai.transferFrom(address(this), msg.sender, amount); 
//         totalDeposit -= amount;
//         uint daiToRecieve = mulExp(amount, getExchangeRate());
//         bond.burn(msg.sender, daiToRecieve);
//         withdrawDaiFromAave(daiToRecieve);
//     }

//     function addCollateral() payable external {
//         require(msg.value > 0, "Value must be bigger than zero");
//         usersCollateral[msg.sender] += msg.value;
//         totalCollateral += msg.value;
//         sendWethToAave(msg.value);
//     }

//     function removeCollateral(uint amount) external {
//         require(amount > 0);
//         require(usersCollateral[msg.sender] > 0, "You don't have any collaterals");

//         uint borrowed    = usersBorrowed[msg.sender];
//         uint collaterals = usersCollateral[msg.sender];

//         uint collateralsDai = mulExp(collaterals, ETHPrice);

//         uint limit = percentage(collateralsDai, maxLTV) - borrowed;

//         // uint _amount = min(amount, limit);
//         uint _amount = amount;
//         uint toRemove = mulExp(_amount, ETHPrice); 

//         usersCollateral[msg.sender] -= _amount;
//         totalCollateral -= _amount;

//         withdrawWethFromAave(_amount);

//         payable(msg.sender).transfer(_amount);        
//     }

//     // function borrowDai(uint amount) external {
//     //     require(usersCollateral[msg.sender] > 0, "You don't have any collaterals");

//     //     uint borrowed    = usersBorrowed[msg.sender];
//     //     uint collaterals = usersCollateral[msg.sender];
//     // }
//     function borrowDai(uint256 amount) external {
//         require(usersCollateral[msg.sender] > 0, "you do not have any collaterals");
      
//         uint borrowed = usersBorrowed[msg.sender];
//         uint collateral = usersCollateral[msg.sender];
//         uint left = mulExp(collateral, uint(getLatestPrice())) - borrowed;
//         uint borrowLimit = percentage(left, maxLTV);
     
//         require(borrowLimit >= amount, "you cannot pass the limit");
     
//         dai.transferFrom(address(this), msg.sender, amount);
//         totalBorrowed += amount;
//         withdrawDaiFromAave(amount);
//     }

//     function repay(uint amount) external {
//         require(usersBorrowed[msg.sender] > 0, "You don't have any dep");
//         uint ratio = getExp(totalBorrowed , totalDeposit);
//         uint interestMul = getExp(borrowRate - baseRate, ratio);
//         uint rate = (ratio * interestMul) +baseRate;
//         uint fee = amount * rate;
//         uint paid = amount - fee;

//         totalReserve += fee;
//         usersBorrowed[msg.sender] -= paid;
//         totalBorrowed -= paid; 

//         sendDaiToAave(amount);
//     }

//     function liquidation() external onlyOwner() {


//     }



//     function getCash() public view returns (uint256) {
//         return totalDeposit - totalBorrowed;
//     }

//     function getExchangeRate() public view returns (uint256) {
//         if (this.totalSupply() == 0) {
//             return 1000000000000000000;
//         }
//         uint256 cash = getCash();
//         uint256 num = cash + totalBorrowed + totalReserve;
//         return getExp(num, this.totalSupply());
//     }
//     function getLatestPrice() public view returns (int256) {
//         (, int256 price, , , ) = priceFeed.latestRoundData();
//         return price * 10**10;
//     }


//     //////////////// aave functions /////////////////////
//      function sendDaiToAave(uint256 _amount) internal {
//         dai.approve(address(aave), _amount);
//         aave.deposit(address(dai), _amount, address(this), 0);
//     }

//     function withdrawDaiFromAave(uint256 _amount) internal {
//         aave.withdraw(address(dai), _amount, msg.sender);
//     }

//     function sendWethToAave(uint256 _amount) internal {
//         wethGateway.depositETH{value: _amount}(address(aave), address(this), 0);
//     }

//     function withdrawWethFromAave(uint256 _amount) internal {
//         aWeth.approve(address(wethGateway), _amount);
//         wethGateway.withdrawETH(address(aave), _amount, address(this));
//     }


// }