// // SPDX-License-Identifier: Unlicense

// // import opened Microsoft.Dafny.Dafny;

// // Dummy imports to simulate interfaces and modules in Dafny
// module ERC20 {
//   class ERC20Burnable {}
// }

// module Ownable {}

// module AggregatorV3Interface {}

// module ISwapRouter {}

// module Math {}

// module ILendingPool {
//   class LendingPool {
//     method deposit(asset: address, amount: uint256, onBehalfOf: address, referralCode: uint16) {}
//     method withdraw(asset: address, amount: uint256, to: address): uint256 { return 0 }
//   }
// }

// module IWETHGateway {
//   class WETHGateway {
//     method depositETH(lendingPool: address, onBehalfOf: address, referralCode: uint16) {}
//     method withdrawETH(lendingPool: address, amount: uint256, onBehalfOf: address) {}
//   }
// }

// module IERC20 {
//   class ERC20 {
//     method transferFrom(sender: address, recipient: address, amount: uint256) {}
//     method approve(spender: address, amount: uint256) {}
//     method balanceOf(owner: address): uint256 { return 0 }
//   }
// }

// module IUniswapRouter {
//   class UniswapRouter is ISwapRouter {
//     method refundETH() {}
//   }
// }

// module BondToken {
//   class BondToken extends ERC20.ERC20Burnable, Ownable, Math {
//     var totalBorrowed: uint256 := 0
//     var totalReserve: uint256 := 0
//     var totalDeposit: uint256 := 0
//     var maxLTV: uint256 := 4 // 1 = 20%
//     var ethTreasury: uint256 := 0
//     var totalCollateral: uint256 := 0
//     var baseRate: uint256 := 20000000000000000
//     var fixedAnnuBorrowRate: uint256 := 300000000000000000

//     var aave: ILendingPool.LendingPool
//     var wethGateway: IWETHGateway.WETHGateway
//     var dai: IERC20.ERC20
//     var aDai: IERC20.ERC20
//     var aWeth: IERC20.ERC20
//     var priceFeed: AggregatorV3Interface
//     var uniswapRouter: IUniswapRouter.UniswapRouter
//     var weth: IERC20.ERC20

//     var usersCollateral: map<address, uint256> := map[]
//     var usersBorrowed: map<address, uint256> := map[]

//     constructor () {
//       aave := new ILendingPool.LendingPool()
//       wethGateway := new IWETHGateway.WETHGateway()
//       dai := new IERC20.ERC20()
//       aDai := new IERC20.ERC20()
//       aWeth := new IERC20.ERC20()
//       priceFeed := new AggregatorV3Interface()
//       uniswapRouter := new IUniswapRouter.UniswapRouter()
//       weth := new IERC20.ERC20()
//     }

//     method bondAsset(_amount: uint256) {
//       dai.transferFrom(msg.sender, this, _amount)
//       totalDeposit := totalDeposit + _amount
//       _sendDaiToAave(_amount)
//       var bondsToMint := getExp(_amount, getExchangeRate())
//       _mint(msg.sender, bondsToMint)
//     }

//     method unbondAsset(_amount: uint256) {
//       assert _amount <= balanceOf(msg.sender), "Not enough bonds!"
//       var daiToReceive := mulExp(_amount, getExchangeRate())
//       totalDeposit := totalDeposit - daiToReceive
//       burn(_amount)
//       _withdrawDaiFromAave(daiToReceive)
//     }

//     method addCollateral() {
//       assert msg.value != 0, "Cant send 0 ethers"
//       usersCollateral[msg.sender] := usersCollateral[msg.sender] + msg.value
//       totalCollateral := totalCollateral + msg.value
//       _sendWethToAave(msg.value)
//     }

//     method removeCollateral(_amount: uint256) {
//       var wethPrice := uint256(_getLatestPrice())
//       var collateral := usersCollateral[msg.sender]
//       assert collateral > 0, "Dont have any collateral"
//       var borrowed := usersBorrowed[msg.sender]
//       var amountLeft := mulExp(collateral, wethPrice) - borrowed
//       var amountToRemove := mulExp(_amount, wethPrice)
//       assert amountToRemove < amountLeft, "Not enough collateral to remove"
//       usersCollateral[msg.sender] := usersCollateral[msg.sender] - _amount
//       totalCollateral := totalCollateral - _amount
//       _withdrawWethFromAave(_amount)
//       // No equivalent of payable in Dafny, just illustrate the intent
//     }

//     method borrow(_amount: uint256) {
//       assert _amount <= _borrowLimit(), "No collateral enough"
//       usersBorrowed[msg.sender] := usersBorrowed[msg.sender] + _amount
//       totalBorrowed := totalBorrowed + _amount
//       _withdrawDaiFromAave(_amount)
//     }

//     method repay(_amount: uint256) {
//       assert usersBorrowed[msg.sender] > 0, "Doesnt have a debt to pay"
//       dai.transferFrom(msg.sender, this, _amount)
//       var (fee, paid) := calculateBorrowFee(_amount)
//       usersBorrowed[msg.sender] := usersBorrowed[msg.sender] - paid
//       totalBorrowed := totalBorrowed - paid
//       totalReserve := totalReserve + fee
//       _sendDaiToAave(_amount)
//     }

//     method calculateBorrowFee(_amount: uint256): (uint256, uint256) {
//       var borrowRate := _borrowRate()
//       var fee := mulExp(_amount, borrowRate)
//       var paid := _amount - fee
//       return (fee, paid)
//     }

//     method liquidation(_user: address) {
//       assert msg.sender == this.Owner(), "Only owner can call liquidation"
//       var wethPrice := uint256(_getLatestPrice())
//       var collateral := usersCollateral[_user]
//       var borrowed := usersBorrowed[_user]
//       var collateralToUsd := mulExp(wethPrice, collateral)
//       if borrowed > percentage(collateralToUsd, maxLTV) {
//         _withdrawWethFromAave(collateral)
//         var amountDai := _convertEthToDai(collateral)
//         totalReserve := totalReserve + amountDai
//         usersBorrowed[_user] := 0
//         usersCollateral[_user] := 0
//         totalCollateral := totalCollateral - collateral
//       }
//     }

//     method getExchangeRate(): uint256 {
//       if totalSupply() == 0 {
//         return 1000000000000000000
//       }
//       var cash := getCash()
//       var num := cash + totalBorrowed + totalReserve
//       return getExp(num, totalSupply())
//     }

//     method getCash(): uint256 {
//       return totalDeposit - totalBorrowed
//     }

//     method harvestRewards() {
//       assert msg.sender == this.Owner(), "Only owner can call harvestRewards"
//       var aWethBalance := aWeth.balanceOf(this)
//       if aWethBalance > totalCollateral {
//         var rewards := aWethBalance - totalCollateral
//         _withdrawWethFromAave(rewards)
//         ethTreasury := ethTreasury + rewards
//       }
//     }

//     method convertTreasuryToReserve() {
//       assert msg.sender == this.Owner(), "Only owner can call convertTreasuryToReserve"
//       var amountDai := _convertEthToDai(ethTreasury)
//       ethTreasury := 0
//       totalReserve := totalReserve + amountDai
//     }

//     method _borrowLimit(): uint256 {
//       var amountLocked := usersCollateral[msg.sender]
//       assert amountLocked > 0, "No collateral found"
//       var amountBorrowed := usersBorrowed[msg.sender]
//       var wethPrice := uint256(_getLatestPrice())
//       var amountLeft := mulExp(amountLocked, wethPrice) - amountBorrowed
//       return percentage(amountLeft, maxLTV)
//     }

//     method _sendDaiToAave(_amount: uint256) {
//       dai.approve(aave, _amount)
//       aave.deposit(dai, _amount, this, 0)
//     }

//     method _withdrawDaiFromAave(_amount: uint256) {
//       aave.withdraw(dai, _amount, msg.sender)
//     }

//     method _sendWethToAave(_amount: uint256) {
//       wethGateway.depositETH(this.aave, this, 0)
//     }

//     method _withdrawWethFromAave(_amount: uint256) {
//       aWeth.approve(wethGateway, _amount)
//       wethGateway.withdrawETH(this.aave, _amount, this)
//     }

//     method getCollateral(): uint256 {
//       return usersCollateral[msg.sender]
//     }

//     method getBorrowed(): uint256 {
//       return usersBorrowed[msg.sender]
//     }

//     method balance(): uint256 {
//       return aDai.balanceOf(this)
//     }

//     method _getLatestPrice(): int256 {
//       var price: int256
//       // Dummy return for the price
//       price := 3000 * 10**10
//       return price
//     }

//     method _utilizationRatio(): uint256 {
//       return getExp(totalBorrowed, totalDeposit)
//     }

//     method _interestMultiplier(): uint256 {
//       var uRatio := _utilizationRatio()
//       var num := fixedAnnuBorrowRate - baseRate
     

