// const { ethers } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  console.log("Deploying SmartAccountFactory...");
  const Paymaster = await deploy("Paymaster", {
    from: deployer,
    args: [],
    log: true,
  });

  console.log("Paymaster deployed to:", Paymaster.address);
  console.log("--------------------------------------------------------");
};

module.exports.tags = ["Paymaster"];
