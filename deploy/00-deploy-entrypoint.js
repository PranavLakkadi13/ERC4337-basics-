const { ethers } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  console.log("Deploying EntryPoint...");
  const EntryPoint = await deploy("EntryPoint", {
    from: deployer,
    args: [], 
    log: true,
  });

  console.log("Entry Point deployed to:", EntryPoint.address);
  console.log("--------------------------------------------------------");
};

module.exports.tags = ["EntryPoint"];