// SPDX-License-Identifier:MIT
pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    error HelperConfig__InvalidEntryPoint();
    error HelperConfig__InvalidChainId();

    // the actual constructor argumnet that will be passed when deploying the minimal account
    struct NetworkConfig {
        address entryPoint;
        address account;
    }

    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant ZKSYNC_SEPOLIA_CHAIN_ID = 300;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
    address public constant BURNER_WALLET = 0x1B150538E943F00127929f7eeB65754f7beB0B6d;

    address DEFAULT_FOUNDRY_CALLER = address(uint160(uint256(keccak256("foundry default caller"))));

    NetworkConfig public localNetworkConfig;
    mapping(uint256 chainId => NetworkConfig) public networkConfigs;

    constructor() {
        networkConfigs[ETH_SEPOLIA_CHAIN_ID] = getEthSepoliaConfig();
        networkConfigs[ZKSYNC_SEPOLIA_CHAIN_ID] = getZKSyncSepoliaConfig();
    }

    //also note that each chain will have just 1 entry point contract deployed
    function getEthSepoliaConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({entryPoint: 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789, account: BURNER_WALLET});
    }

    function getZKSyncSepoliaConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({entryPoint: address(0), account: BURNER_WALLET});
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (localNetworkConfig.account != address(0)) {
            return localNetworkConfig;
        }
        // else we will deploy a local instance (mocks)


        return NetworkConfig({entryPoint: address(0), account: DEFAULT_FOUNDRY_CALLER});
    }

    function getConfig() public returns (NetworkConfig memory) {
        return getConfigByChainId(block.chainid);
    }

    // using account address zero check since it will be better to use rather than checking for entrypoint address sice
    // some chains have entrypoint address zero as a valid address
    function getConfigByChainId(uint256 chainId) public returns (NetworkConfig memory) {
        if (chainId == LOCAL_CHAIN_ID) {
            return getOrCreateAnvilEthConfig();
        } else if (networkConfigs[chainId].account != address(0)) {
            return networkConfigs[chainId];
        } else {
            revert HelperConfig__InvalidEntryPoint();
        }
    }
}
