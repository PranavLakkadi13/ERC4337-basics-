const { hre, ethers, deployments, getNamedAccounts } = require("hardhat");

const Factory_Nonce = 1;
const Factory_Adderess = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";
const EntryPoint_Address = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

/**
 * CREATE: This opcode is used to create a new address but cant be determined at compile time.
 * CREATE2: This opcode is used to create a new address deterministically based on the address 
 *          of the creator and the salt.
 * 
 * This opcodes are used in the account factory to determine the account address of the smart account
 * that will be created.
 * 
 * currently since we are using 'new' keyword it using the CREATE opcode to create the smart account.
 */

async function main() {
    const accounts = await ethers.getSigners();

    const entryPoint = await ethers.getContractAt(
      "EntryPoint",
      "0x5FbDB2315678afecb367f032d93F642f64180aa3"
    );

    const sender = ethers.getCreateAddress({
        from: Factory_Adderess,
        nonce: Factory_Nonce,
    });

    const AccountFactory = ethers.getContractFactory("SmartAccountFactory");
    const initCode = Factory_Adderess + ((await AccountFactory).interface.encodeFunctionData("createSmartAccount", [accounts[0].address])).slice(2);

    const Account = ethers.getContractFactory("SmartAccount");
    const callData = (await Account).interface.encodeFunctionData("execute", []);

    const nonce = await entryPoint.getNonce(sender,0);

    const userOp = {
        sender, // smart account address 
        nonce,
        initCode,
        callData,
        callGasLimit: 200_000 ,
        verificationGasLimit: 200_000,
        preVerificationGas: 50_000,
        maxFeePerGas: ethers.parseUnits("10", "gwei"),
        maxPriorityFeePerGas: ethers.parseUnits("5", "gwei"),
        paymasterAndData: "0x",
        signature: "0x"
    }

    const tx = await entryPoint.handleOps([userOp],accounts[0].address);
    const receipt = await tx.wait();
    console,log(receipt);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
