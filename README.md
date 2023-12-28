To use this Repository install Foundry testing Framework.
Then create API key to interect with blockchain. To get API keys use Alchemy, Infura

After getting Key execute the Following Commands

    FORK_URL=YOUR_API_KEY
    forge test -vv --gas-report --fork-url $FORK_URL --match-path test/UniswapV3Swap.t.sol
