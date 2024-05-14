const { ethers } = require("hardhat");
const { test } = require("mocha");

async function main() {

    const [signer0] = await ethers.getSigners();
    const signature = await signer0.signMessage(ethers.getBytes(ethers.id("Test")));

    const Test = ethers.getContractFactory("Test");
    const test = await (await Test).deploy(signature);

    console.log("Test signer Address ", signer0.address);
}    

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });