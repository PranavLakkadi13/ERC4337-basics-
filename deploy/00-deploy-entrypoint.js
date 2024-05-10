const { ethers } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  console.log("Deploying MyContract...");
  const myContract = await deploy("MyContract", {
    from: deployer,
    args: [], // Pass constructor arguments here if needed
    log: true,
  });

  console.log("MyContract deployed to:", myContract.address);
};

module.exports.tags = ["MyContract"];