// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { EntryPoint } from "@account-abstraction/contracts/core/EntryPoint.sol";
import { IAccount } from "@account-abstraction/contracts/interfaces/IAccount.sol";
import { UserOperation } from "@account-abstraction/contracts/interfaces/UserOperation.sol";
// import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract SmartAccount is IAccount {

    uint256 public counter;
    address public owner;

    constructor(address _owner) {
        owner = _owner;
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


contract SmartAccountFactory {

    function createSmartAccount(address _owner) external returns (address) {
        SmartAccount account = new SmartAccount(_owner);
        return address(account);
    }
}