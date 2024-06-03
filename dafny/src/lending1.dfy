// include "util/number.dfy"
// include "util/maps.dfy"
// include "util/tx.dfy"
// include "erc20.dfy"

// import opened Number
// import opened Maps
// import opened Tx

// module BondToken {
//     import opened Math

//     class BondToken {
//         var totalBorrowed: u256 
//         var totalReserve: u256
//         var totalDeposit: u256
//         var maxLTV: u256
//         var ethTreasury: u256
//         var totalCollateral: u256
//         var baseRate: u256
//         var fixedAnnuBorrowRate: u256
//         var usersCollateral: map<u160, u256>
//         var usersBorrowed: map<u160, u256>

//         constructor () {
//             totalBorrowed := 0;
//             totalReserve := 0;
//             totalDeposit := 0;
//             maxLTV := 4;
//             ethTreasury := 0;
//             totalCollateral := 0;
//             baseRate := 20000000000000000;
//             fixedAnnuBorrowRate := 300000000000000000;
//             usersCollateral := map [];
//             usersBorrowed := map [];
//             // ERC20("Bond DAI", "bDAI")
//         }

//         method bondAsset(msg: Transaction, amount: u256) returns (r: Result<()>) {
//             totalDeposit := totalDeposit + amount;
//             // _sendDaiToAave(amount)
//             var bondsToMint := getExp(amount, getExchangeRate());
//             // _mint(msgSender, bondsToMint)
//         }

//         method unbondAsset(amount: u256, msgSender: u160) {
//             assert amount <= balanceOf(msgSender);
//             var daiToReceive := mulExp(amount, getExchangeRate());
//             totalDeposit := totalDeposit - daiToReceive;
//             // burn(amount)
//             // _withdrawDaiFromAave(daiToReceive)
//         }

//         method addCollateral(msgValue: u256, msgSender: u160) {
//             assert msgValue != 0;
//             usersCollateral := usersCollateral[msgSender := msgValue + (if usersCollateral[msgSender?] then usersCollateral[msgSender] else 0)];
//             totalCollateral := totalCollateral + msgValue;
//             // _sendWethToAave(msgValue)
//         }

//         method removeCollateral(amount: u256, msgSender: u160) {
//             var wethPrice := _getLatestPrice();
//             var collateral := usersCollateral[msgSender];
//             assert collateral > 0;
//             var borrowed := usersBorrowed[msgSender];
//             var amountLeft := mulExp(collateral, wethPrice) - borrowed;
//             var amountToRemove := mulExp(amount, wethPrice);
//             assert amountToRemove < amountLeft;
//             usersCollateral := usersCollateral[msgSender := collateral - amount];
//             totalCollateral := totalCollateral - amount;
//             // _withdrawWethFromAave(amount)
//             // payable(u160(this)).transfer(amount)
//         }

//         method borrow(amount: u256, msgSender: u160) {
//             assert amount <= borrowLimit_(msgSender);
//             usersBorrowed := usersBorrowed[msgSender := amount + (if usersBorrowed[msgSender?] then usersBorrowed[msgSender] else 0)];
//             totalBorrowed := totalBorrowed + amount;
//             // _withdrawDaiFromAave(amount)
//         }

//         method repay(amount: u256, msgSender: u160) {
//             assert usersBorrowed[msgSender] > 0;
//             // dai.transferFrom(msgSender, u160(this), amount)
//             var (fee, paid) := calculateBorrowFee(amount);
//             usersBorrowed := usersBorrowed[msgSender := usersBorrowed[msgSender] - paid];
//             totalBorrowed := totalBorrowed - paid;
//             totalReserve := totalReserve + fee;
//             // _sendDaiToAave(amount)
//         }

//         method calculateBorrowFee(amount: u256) returns (fee: u256, paid: u256) {
//             var borrowRate := _borrowRate();
//             fee := mulExp(amount, borrowRate);
//             paid := amount - fee;
//         }

//         method liquidation(user: u160) {
//             var wethPrice := _getLatestPrice();
//             var collateral := usersCollateral[_user];
//             var borrowed := usersBorrowed[_user];
//             var collateralToUsd := mulExp(wethPrice, collateral);
//             if borrowed > percentage(collateralToUsd, maxLTV) {
//                 // _withdrawWethFromAave(collateral)
//                 var amountDai := _convertEthToDai(collateral);
//                 totalReserve := totalReserve + amountDai;
//                 usersBorrowed := usersBorrowed[_user := 0];
//                 usersCollateral := usersCollateral[_user := 0];
//                 totalCollateral := totalCollateral - collateral;
//             }
//         }

//         method getExchangeRate() returns (rate: u256) {
//             if totalSupply() == 0 {
//                 return 1000000000000000000;
//             }
//             var cash := getCash();
//             var num := cash + totalBorrowed + totalReserve;
//             return getExp(num, totalSupply());
//         }

//         method getCash() returns (cash: u256) {
//             return totalDeposit - totalBorrowed;
//         }

//         method harvestRewards() {
//             var aWethBalance := aWeth.balanceOf(u160(this));
//             if aWethBalance > totalCollateral {
//                 var rewards := aWethBalance - totalCollateral;
//                 // _withdrawWethFromAave(rewards)
//                 ethTreasury := ethTreasury + rewards;
//             }
//         }

//         method convertTreasuryToReserve() {
//             var amountDai := _convertEthToDai(ethTreasury);
//             ethTreasury := 0;
//             totalReserve := totalReserve + amountDai;
//         }

//         method borrowLimit_(msgSender: u160) returns (limit: u256) {
//             var amountLocked := usersCollateral[msgSender];
//             assert amountLocked > 0;
//             var amountBorrowed := usersBorrowed[msgSender];
//             var wethPrice := _getLatestPrice();
//             var amountLeft := mulExp(amountLocked, wethPrice) - amountBorrowed;
//             return percentage(amountLeft, maxLTV);
//         }

//         method _sendDaiToAave(amount: u256) {
//             // dai.approve(u160(aave), amount)
//             // aave.deposit(u160(dai), amount, u160(this), 0)
//         }

//         method _withdrawDaiFromAave(amount: u256) {
//             // aave.withdraw(u160(dai), amount, msg.sender)
//         }

//         method _sendWethToAave(amount: u256) {
//             // wethGateway.depositETH{value: amount}(u160(aave), u160(this), 0)
//         }

//         method _withdrawWethFromAave(amount: u256) {
//             // aWeth.approve(u160(wethGateway), amount)
//             // wethGateway.withdrawETH(u160(aave), amount, u160(this))
//         }

//         method getCollateral(msgSender: u160) returns (collateral: u256) {
//             return usersCollateral[msgSender];
//         }

//         method getBorrowed(msgSender: u160) returns (borrowed: u256) {
//             return usersBorrowed[msgSender];
//         }

//         method balance() returns (bal: u256) {
//             // return aDai.balanceOf(u160(this))
//         }

//         method _getLatestPrice() returns (price: u256) {
//             // (, int256 price, , , ) = priceFeed.latestRoundData()
//             // return price * 10**10
//         }

//         method _utilizationRatio() returns (ratio: u256) {
//             return getExp(totalBorrowed, totalDeposit);
//         }

//         method _interestMultiplier() returns (multiplier: u256) {
//             var uRatio := _utilizationRatio();
//             var num := fixedAnnuBorrowRate - baseRate;
//             return getExp(num, uRatio);
//         }

//         method _borrowRate() returns (rate: u256) {
//             var uRatio := _utilizationRatio();
//             var interestMul := _interestMultiplier();
//             var product := mulExp(uRatio, interestMul);
//             return product + baseRate;
//         }

//         method _depositRate() returns (rate: u256) {
//             var uRatio := _utilizationRatio();
//             var bRate := _borrowRate();
//             return mulExp(uRatio, bRate);
//         }

//         method _convertEthToDai(amount: u256) returns (amountOut: u256) {
//             assert amount > 0;
//             var deadline := now + 15;
//             var tokenIn := weth;
//             var tokenOut := dai;
//             var fee := 3000;
//             var recipient := u160(this);
//             var amountIn := amount;
//             var amountOutMinimum := 1;
//             var sqrtPriceLimitX96 := 0;

//             var params := ISwapRouter.ExactInputSingleParams(
//                 tokenIn,
//                 tokenOut,
//                 fee,
//                 recipient,
//                 deadline,
//                 amountIn,
//                 amountOutMinimum,
//                 sqrtPriceLimitX96
//             );

//             amountOut := uniswapRouter.exactInputSingle{value: amount}(params);
//             uniswapRouter.refundETH();
//             return amountOut;
//         }

//         method balanceOf(addr: u160) returns (bal: u256) {
//             // return balanceOf(addr)
//         }
//     }
// }