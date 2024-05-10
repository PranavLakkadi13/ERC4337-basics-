require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-foundry");
require("hardhat-deploy");
require("dotenv").config();

const RPC_URL_Alchemy_SEPOLIA = process.env.RPC_URL_Alchemy_SEPOLIA;
const Private_Key = process.env.Private_Key;
const RPC_URL_POLYGON = process.env.RPC_URL_POLYGON;
const PolygonScan_API_KEY = process.env.PolygonScan_API_KEY;
const Etherscan_API_KEY = process.env.Etherscan_API_KEY;
const Coinmarketcap_API_KEY = process.env.Coinmarketcap_API_KEY;
const RPC_URL_Alchemy_MAINNET = process.env.RPC_URL_Alchemy_MAINNET;

const Private_Key_G = process.env.Private_Key_G;
const RPC_URL_G = process.env.RPC_URL_G;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      { version: "0.4.19" },
      { version: "0.8.20" },
      { version: "0.6.6" },
      { version: "0.8.21" },
    ],
    settings: {
      optimizer: {
        enabled: true,
        runs: 10000,
      },
    },  
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
    player: {
      default: 1,
    },
  },
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 31337,
      blockConfirmations: 1,
      // forking: {
      //   url: RPC_URL_Alchemy_MAINNET,
      // },
      gaslimit: 30000000,
      blockGasLimit: 30000000,
      allowUnlimitedContractSize: true,
    },
    sepolia: {
      url: RPC_URL_Alchemy_SEPOLIA,
      accounts: [Private_Key],
      chainId: 11155111,
      blockConfirmations: 6,
    },
    polygon: {
      url: RPC_URL_POLYGON,
      accounts: [Private_Key],
      chainId: 80001,
      blockConfirmations: 6,
    },
  },
  etherscan: {
    apiKey: Etherscan_API_KEY,
    customChains: [
      {
        network: "sepolia",
        chainId: 11155111,
        urls: {
          apiURL: "https://api-sepolia.etherscan.io/api",
          browserURL: "https://sepolia.etherscan.io",
        },
      },
    ],
  },
  polygonscan: {
    apiKey: PolygonScan_API_KEY,
  },
  gasReporter: {
    enabled: true,
    // outputFile: "gas-reporter.txt",
    noColors: true,
    currency: "USD",
    coinmarketcap: Coinmarketcap_API_KEY,
    token: "ETH",
  },
  mocha: {
    timeout: 1000000,
  },
};
