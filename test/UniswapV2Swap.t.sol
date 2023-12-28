// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/UniswapV2Swap.sol";
contract CounterTest is Test {

    UniswapV2Swap private swap = new UniswapV2Swap();


    address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    IWETH private weth = IWETH(WETH);
    IERC20 private dai= IERC20(DAI);
    IERC20 private usdc = IERC20(USDC);

    function setUp() public {}
    function testSingleHopExactAmountIn()public{
        weth.deposit{value:1e18}();
        weth.approve(address(swap), 1e18);

        uint amountOut = swap.swapSingleHopExactAmountIn(1e18, 0);
        console.log("DAI Receieved: ",amountOut);
        console.log("DAI in Decimals:",amountOut/1e18);

    }

    function testMultiHopExactAmountIn()public{
        weth.deposit{value:1e18}();
        weth.approve(address(swap), 1e18);

        uint amountOut = swap.swapMultiHopExactAmountIn(1e18, 0);
        console.log("USDC Received: ",usdc.balanceOf(address(this)));
        console.log("USDC in Decimals: ",amountOut/1e6);
    }

    function testSingleHopExactAmountOut()public{
        weth.deposit{value:1e18}();
        weth.approve(address(swap), 1e18);

        uint amountOut = swap.swapSingleHopExactAmountOut(1e18, 200*1e18);
        console.log("WETH Balance After Swap: ",weth.balanceOf(address(this)));
        console.log("DAI Received: ",dai.balanceOf(address(this)));
        console.log("DAI in Decimal: ",amountOut/1e18);
    }
    

    function testMultiHopExactAmountOut()public{
        weth.deposit{value:1e18}();
        weth.approve(address(swap), 1e18);

        uint amountOut = swap.swapMultiHopExactAmountOut(1e18, 20*1e6);
        console.log("WETH Balance After Swap: ",weth.balanceOf(address(this)));
        console.log("USDC Received: ",usdc.balanceOf(address(this)));
        console.log("USDC in Decimal: ",amountOut/1e6);
    }

}