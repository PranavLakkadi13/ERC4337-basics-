// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { EntryPoint } from "@account-abstraction/contracts/core/EntryPoint.sol";
import { IAccount } from "@account-abstraction/contracts/interfaces/IAccount.sol";
import { UserOperation } from "@account-abstraction/contracts/interfaces/UserOperation.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "hardhat/console.sol";
import { Create2 } from "@openzeppelin/contracts/utils/Create2.sol";


contract Test {
    constructor (bytes memory sig) {

        /**
         * @note Here we are checking the signauture of a person who signed the message "Test"
         * But the problem with that is thta signature is stored on chain and since its public 
         * anyone can see it and use it to sign when the message is "Test" and get the same result.
         * here any malicious user can use this kind of deterministic signature to sign the message
         * and pretend to be the owner 
         * 
         * The above attack is called the Signature replay attack
         * 
         * Thats y there needs to be a protection against replay attacks especially in a public network 
         * Thats where we try to use the nonce a unique random number or a more robust solution like
         * taking the signature using the other parameters of the transaction rather than just a single
         * message 
         * 
         */

        address recovered = ECDSA.recover(ECDSA.toEthSignedMessageHash(keccak256("Test")), sig);
        console.log("Recovered: %s", recovered);
    }
}

contract SmartAccount is IAccount {

    uint256 public counter;
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function validateUserOp (
        UserOperation calldata userOp ,
        bytes32 userOpHash , 
        uint256 /* missingAccountFunds */ )
    external view returns (uint256 validationData) {
        // The below message can be susceptible to replay attacks
        // address recovered = ECDSA.recover(ECDSA.toEthSignedMessageHash(keccak256("Test")), userOp.signature);
        
        // here  a more robust solution is to use the hash of the userOp to check the signature
        // since it has a nonce and different parameters of the transaction it is more secure
        // and less susceptible to replay attacks 

        // The userOpHash is the hash of the userOp struct and the address sender and the chain Id 
        // and the signature is specific to a particular chain 

        address recovered = ECDSA.recover(ECDSA.toEthSignedMessageHash(userOpHash), userOp.signature);
        if (recovered == owner) {
            return 0; // valid signature
        }
        else {
            return 1; // invalid signature
        }
    }

    function execute() external {
        counter++;
    }

}


contract SmartAccountFactory {

    function createSmartAccount(address _owner) external returns (address) {
        // Cant use this method since it uses the create opcode which is not allowed in AA 
        // since the create opcode uses the nonce as a argument and the bundler maybe not to 
        // be able to accurately simulate the changes 
        // 
        // SmartAccount account = new SmartAccount(_owner);
        // return address(account);
        bytes32 salt = bytes32(uint256(uint160(_owner)));
        bytes memory bytecode = abi.encodePacked(type(SmartAccount).creationCode,abi.encode(_owner));
        
        address addr = Create2.computeAddress(salt, keccak256(bytecode));
        if (addr.code.length > 0) {
            return addr;
        }
        
        return Create2.deploy(0, salt, bytecode);
    }
}