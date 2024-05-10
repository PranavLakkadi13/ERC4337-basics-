// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { EntryPoint } from "@account-abstraction/contracts/core/EntryPoint.sol";
import { IAccount } from "@account-abstraction/contracts/interfaces/IAccount.sol";
import { UserOperation } from "@account-abstraction/contracts/interfaces/UserOperation.sol";

contract Account is IAccount {

    function validateUserOp (
        UserOperation calldata userOp,
        bytes32 userOpHash, 
        uint256 missingAccountFunds )
    external returns (uint256 validationData) {
        return 0;
    }
    
}