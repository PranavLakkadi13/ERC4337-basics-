// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { SmartAccount } from "../contracts/Account.sol";
import { Test } from "forge-std/Test.sol";
import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract AccountTest is Test {  

    struct UserOperation {
        address sender;
        uint256 nonce;
        bytes initCode;
        bytes callData;
        uint256 callGasLimit;
        uint256 verificationGasLimit;
        uint256 preVerificationGas;
        uint256 maxFeePerGas;
        uint256 maxPriorityFeePerGas;
        bytes paymasterAndData;
        bytes signature;
    }

    SmartAccount public account;
    address owner = makeAddr("bob");
    address alice = makeAddr("alice");

    function setUp() public {   
        vm.prank(owner);
        account = new SmartAccount(address(owner));
    }

    function testDefaultOwner() public view {
        assert(account.owner() == owner);
    }

    function testExecuteOperation() public {
        account.execute();
        assertEq(account.counter(),1);
    }

    function testValidateUserOp() public {
        
        bytes32 x = ECDSA.toEthSignedMessageHash(keccak256("Test"));
        bytes memory sig = sig(x, owner);

        UserOperation memory userOp = UserOperation({
            signature: sig,
            nonce: 0,
            gasPrice: 0,
            gasLimit: 0,
            to: address(0),
            value: 0,
            data: ""
        });
        assertEq(account.validateUserOp(userOp, keccak256(abi.encode(userOp)), 0), 0);
    }
}