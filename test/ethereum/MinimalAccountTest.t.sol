// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {MinimalAccount} from "../../src/ethereum/MinimalAccount.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {DeployMinimalAccount} from "../../script/DeployMinimalAccount.s.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {console} from "forge-std/console.sol";

contract TestMinimalAccount is Test { 

    MinimalAccount public  minimalAccount;
    HelperConfig public helperConfig;
    ERC20Mock public usdc;
    
    function setUp() public {
        DeployMinimalAccount deployMinimalAccount = new DeployMinimalAccount();
        (helperConfig, minimalAccount) = deployMinimalAccount.deployMinimalAccount();
        usdc = new ERC20Mock();
    }

    /*
    * The main Goal is to simulate the transaction  flow of a call made from ofchain to the minimal account
    * msg.sender is the minimal account 
    * the entry point is the contract that will be called to call the changes through the minimal Account 
    * the call flow is as follows
       -> USDC Token Approval 
       -> Owner is minimal account, approves some amount sent from ofchain to the entrypoint 
       -> we will simulate the flow and act as te bundler and the altmempool 
    */
    function test_OwnerCanExecute() public {
        assert(usdc.balanceOf(address(minimalAccount)) == 0);

        // the data to passed to the execute function 
        address destination = address(usdc);
        uint256 value = 0;
        bytes memory functionData = abi.encodeWithSelector(ERC20Mock.mint.selector,address(minimalAccount),1000);

        // acting on test 
        vm.prank(minimalAccount.owner());
        minimalAccount.execute(destination, value, functionData);

        // assert 
        assert(usdc.balanceOf(address(minimalAccount)) == 1000);
    }


    function test_NonOwnerCallShouldFail() public {
        address destination = address(usdc);
        uint256 value = 0;
        bytes memory functionData = abi.encodeWithSelector(ERC20Mock.mint.selector,address(minimalAccount),1000);

        // acting on test 
        vm.prank(address(123));
        vm.expectRevert();
        minimalAccount.execute(destination, value, functionData);
    }
}
