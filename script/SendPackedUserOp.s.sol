// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script} from "forge-std/Script.sol";
import {PackedUserOperation} from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";

contract UserOperationCreation is Script {
    function run() public {}

    function generateUserOperation() public returns (PackedUserOperation memory){
        // generate the unsigned user operation
        

        // sign the user operation
    }


    // since this is a unsigned userOp it doesnt return the signature
    function _generateUnsignedPackedUseroperation(bytes memory callData) internal returns (PackedUserOperation memory) {}
}