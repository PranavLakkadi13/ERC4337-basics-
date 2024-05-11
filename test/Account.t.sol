// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { SmartAccount } from "../contracts/Account.sol";
import { Test } from "forge-std/Test.sol";

contract AccountTest is Test {  
    SmartAccount public account;
    address owner = makeAddr("bob");
    address alice = makeAddr("alice");

    function setUp() public {   
        vm.prank(owner);
        account = new SmartAccount();
    }

    function testDefaultOwner() public {
        assert(account.owner() == owner);
    }

    function testExecuteOperation() public {
        account.execute();
        assertEq(account.counter(),1);
    }
}