const { ethers } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();

  console.log("Deploying SmartAccountFactory...");
  const SmartAccountFactory = await deploy("SmartAccountFactory", {
    from: deployer,
    args: [],
    log: true,
  });

    console.log(
      "SmartAccountFactory deployed to:",
      SmartAccountFactory.address
    );
    console.log("--------------------------------------------------------");
};

module.exports.tags = ["SmartAccountFactory"];
