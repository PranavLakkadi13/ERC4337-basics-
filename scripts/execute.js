const { hre, ethers } = require("hardhat");

const Factory_Nonce = 1;
const Factory_Adderess = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";
const EntryPoint_Address = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
const PayMaster_Address = "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0";

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
      EntryPoint_Address
    );

    const sender = ethers.getCreateAddress({
        from: Factory_Adderess,
        nonce: Factory_Nonce,
    });
  
  console.log(sender);

  const [signer0] = await ethers.getSigners();

    // let sender;
    // try {
    //   await entryPoint.getSenderAddress(initCode);
    // } catch (ex) {
    //   sender = "0x" + ex.data.slice(-40);
    // }
  
  const AccountFactory = await ethers.getContractFactory("SmartAccountFactory");
  // const initCode = Factory_Adderess + ((AccountFactory).interface.encodeFunctionData("createSmartAccount", [accounts[0].address])).slice(2);

  // const initCode = Factory_Adderess + AccountFactory.interface.encodeFunctionData("createSmartAccount", [signer0.address]).slice(2);

  const initCode = "0x";

  console.log(initCode); 
  
  console.log({ sender });
  
  await entryPoint.depositTo(PayMaster_Address, { value: ethers.parseEther("10") });
  
  const Account = await ethers.getContractFactory("SmartAccount");
  const callData = Account.interface.encodeFunctionData("execute");
  
  console.log("code works till here");

  const nonce = "0x" + (await entryPoint.getNonce(sender, 0)).toString(16);
  
  console.log("code works till here after the nonce");
    
  const userOp = {
    sender, // smart account address 
    nonce,
    initCode,
    callData,
    callGasLimit: 400_000 ,
    verificationGasLimit: 400_000,
    preVerificationGas: 150_000,
    maxFeePerGas: ethers.parseUnits("10", "gwei"),
    maxPriorityFeePerGas: ethers.parseUnits("5", "gwei"),
    paymasterAndData: PayMaster_Address,
    signature: "0x"
  }

  const userOpHash = await entryPoint.getUserOpHash(userOp);
  
  const signature = await signer0.signMessage(
    ethers.getBytes(userOpHash)
  );

  userOp.signature = signature;

  const tx = await entryPoint.handleOps([userOp],signer0,{
  gasLimit: 1500000, // Adjust this value based on your needs
  });

  console.log("code works till here after the tx");
 
  const receipt = await tx.wait(1);
  console.log(receipt);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
