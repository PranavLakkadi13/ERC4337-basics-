const { ethers } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  console.log("Deploying MyContract...");
  const EntryPoint = await deploy("EntryPoint", {
    from: deployer,
    args: [], 
    log: true,
  });

  console.log("Entry Point deployed to:", EntryPoint.address);
};

module.exports.tags = ["EntryPoint"];