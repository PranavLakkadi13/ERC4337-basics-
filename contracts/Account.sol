// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { EntryPoint } from "@account-abstraction/contracts/core/EntryPoint.sol";
import { IAccount } from "@account-abstraction/contracts/interfaces/IAccount.sol";
import { UserOperation } from "@account-abstraction/contracts/interfaces/UserOperation.sol";
// import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract SmartAccount is IAccount {

    uint256 public counter;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function validateUserOp (
        UserOperation calldata /* userOp */,
        bytes32 /* userOpHash */, 
        uint256 /* missingAccountFunds */ )
    external pure returns (uint256 validationData) {
        return 0;
    }

    function execute() external {
        counter++;
    }

}