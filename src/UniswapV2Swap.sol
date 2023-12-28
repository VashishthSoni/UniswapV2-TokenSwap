// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract UniswapV2Swap {
    address private constant UNISWAPV2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    IUniswapV2Router private constant router = IUniswapV2Router(UNISWAPV2_ROUTER);
    
    IERC20 private weth = IERC20(WETH);
    IERC20 private dai = IERC20(DAI);
    IERC20 private usdc= IERC20(USDC);

    //WETH->DAI
    /// @notice Swap Exact amount of token once with a token.
    /// @param amountIn Amount of token to swap
    /// @param amountOutMin Minimum amount of token to receive
    /// @return uint256 returns the amount received after swap
    function swapSingleHopExactAmountIn(
        uint256 amountIn,
        uint256 amountOutMin
    )external returns(uint256){
        weth.transferFrom(msg.sender, address(this), amountIn);
        weth.approve(address(router), amountIn);

        address[] memory path = new address[](2);
        path[0]=WETH;
        path[1]=DAI;

        uint[] memory amounts = router.swapExactTokensForTokens(amountIn, amountOutMin, path, msg.sender, block.timestamp);
        return amounts[1]; // amounts[0] == weth and amounts[1] = DAI
    }

    //WETH->DAI->USDC
    /// @notice Swap Exact amount with multiple tokens.
    /// @param amountIn Amount of token to swap
    /// @param amountOutMin Minimum amount of token to receive
    /// @return uint256 returns the amount received after swap
    function swapMultiHopExactAmountIn(
        uint256 amountIn,
        uint256 amountOutMin
    )external returns(uint256){
        weth.transferFrom(msg.sender, address(this), amountIn);
        weth.approve(address(router), amountIn);

        address[] memory path = new address[](3);
        path[0]=WETH;
        path[1]=DAI;
        path[2]=USDC;

        uint[] memory amounts = router.swapExactTokensForTokens(amountIn, amountOutMin, path, msg.sender, block.timestamp);
        return amounts[2]; // amounts[0] == weth, amounts[1] = DAI amounts[2] = USDC
    }

    //WETH->DAI
    /// @notice Swap token once and give desired token to the User and refund extra amount 
    /// @param amountInMax Amount of token to swap
    /// @param amountOut Amount of token to receive
    /// @return uint256 returns the amount received after swap
    function swapSingleHopExactAmountOut(
        uint256 amountInMax, 
        uint256 amountOut
    )external returns(uint256){
        weth.transferFrom(msg.sender, address(this), amountInMax);
        weth.approve(address(router), amountInMax);

        address[] memory path = new address[](2);
        path[0]=WETH;
        path[1]=DAI;
        
        uint[] memory amounts = router.swapTokensForExactTokens(amountOut, amountInMax, path, msg.sender, block.timestamp);
        if(amounts[0] < amountInMax){
            weth.transfer(msg.sender, amountInMax -amounts[0]);
        }
        return amounts[1];
    }

    //WETH->DAI->USDC
    /// @notice Swap tokens multiple time and give desired token to the User and refund extra amount 
    /// @param amountInMax Amount of token to swap
    /// @param amountOut Amount of token to receive
    /// @return uint256 returns the amount received after swap
    function swapMultiHopExactAmountOut(
        uint256 amountInMax, 
        uint256 amountOut
    )external returns(uint256){
        weth.transferFrom(msg.sender, address(this), amountInMax);
        weth.approve(address(router), amountInMax);

        address[] memory path = new address[](3);
        path[0]=WETH;
        path[1]=DAI;
        path[2]=USDC;
        uint[] memory amounts = router.swapTokensForExactTokens(amountOut, amountInMax, path, msg.sender, block.timestamp);
        if(amounts[0] < amountInMax){
            weth.transfer(msg.sender, amountInMax -amounts[0]);
        }
        return amounts[2];
    }

}
interface IUniswapV2Router {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

interface IWETH is IERC20 {
    function deposit() external payable;

    function withdraw(uint amount) external;
}
