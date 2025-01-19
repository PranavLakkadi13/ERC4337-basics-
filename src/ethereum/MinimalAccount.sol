// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IAccount} from "@account-abstraction/contracts/interfaces/IAccount.sol";
import {PackedUserOperation} from "@account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract MinimalAccount is IAccount, Ownable {
    constructor() Ownable(msg.sender) {}

    // this is the wallet that i will be owning on chain
    // the entry point contract will call this contract
    // this is the function that is called by the entrypoint to see if any call is valid or not
    function validateUserOp(PackedUserOperation calldata userOp, bytes32 userOpHash, uint256 missingAccountFunds)
        external
        returns (uint256 validationData)
    {
        // a UserOperation is a struct that contains the data that is sent to the wallet that basically says what to do and all
        // the userOpHash is the hash of the userOp which is used in the signature to prove the authenticity
        // the missingAccountFunds is the amount of funds that are sent basically so that the miner can pay for the gas
        
        // since the signature was passed through the useropeartion we need to validate it 
        // @audit can we add a PASSKEY using the signature passed????
        _validateSignature(userOp, userOpHash);


    }

    // the hash is in the EIP-191 format and we need to convert it to the ETH signed message hash -> EIP-712
    function _validateSignature(PackedUserOperation calldata userOp, bytes32 userOpHash) internal view returns(bool) {
        bytes32 ethSignedMessageHash = MessageHashUtils.toEthSignedMessageHash(userOpHash);
    }
}
