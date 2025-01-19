// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {IAccount} from "lib/account-abstraction/contracts/interfaces/IAccount.sol";
import {PackedUserOperation} from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {SIG_VALIDATION_FAILED, SIG_VALIDATION_SUCCESS} from "lib/account-abstraction/contracts/core/Helpers.sol";
import {IEntryPoint} from "lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";

contract MinimalAccount is IAccount, Ownable {
    /*/////////////////////////////////////////////////////////
    ////////////////// CUSTOM ERRORS //////////////////////////
    /////////////////////////////////////////////////////////*/
    error MinimalAccount__FailedTotransfer();
    error MinimalAccount__OnlyEntryPointAllowed();
    error MinimalAccount__OnlyEntryPointOrOwnerAllowed();
    error MinimalAccount__FailedToExecuteCall(bytes);

    /*/////////////////////////////////////////////////////////
    ////////////////// MODIFIER FUNCTIONS /////////////////////
    /////////////////////////////////////////////////////////*/

    modifier requireCallFromOnlyEntryPoint() {
        require(msg.sender == address(i_entryPoint), MinimalAccount__OnlyEntryPointAllowed());
        _;
    }

    modifier requireCallFromEntryPointOrOwner() {
        require(
            msg.sender == address(i_entryPoint) || msg.sender == owner(), MinimalAccount__OnlyEntryPointOrOwnerAllowed()
        );
        _;
    }

    /*/////////////////////////////////////////////////////////
    ////////////////// STATE VARIABLES ////////////////////////
    /////////////////////////////////////////////////////////*/

    IEntryPoint private immutable i_entryPoint;

    /*/////////////////////////////////////////////////////////
    ////////////////// FUNCTIONS //////////////////////////////
    /////////////////////////////////////////////////////////*/
    constructor(address _entrypoint) Ownable(msg.sender) {
        i_entryPoint = IEntryPoint(_entrypoint);
    }

    receive() external payable {}

    /*/////////////////////////////////////////////////////////
    ////////////////// EXTERNAL FUNCTIONS /////////////////////
    /////////////////////////////////////////////////////////*/

    // this is the wallet that i will be owning on chain
    // the entry point contract will call this contract
    // this is the function that is called by the entrypoint to see if any call is valid or not
    // @audit we can try to restrict that only the netrypoint contract can call this function
    function validateUserOp(PackedUserOperation calldata _userOp, bytes32 _userOpHash, uint256 _missingAccountFunds)
        external
        requireCallFromOnlyEntryPoint
        returns (uint256 validationData)
    {
        // a UserOperation is a struct that contains the data that is sent to the wallet that basically says what to do and all
        // the userOpHash is the hash of the userOp which is used in the signature to prove the authenticity
        // the missingAccountFunds is the amount of funds that are sent basically so that the miner can pay for the gas

        // since the signature was passed through the useropeartion we need to validate it
        // @audit can we add a PASSKEY using the signature passed???? ----> refer the IAccount file to understand how to return data
        validationData = _validateSignature(_userOp, _userOpHash);
        // we can add a 1 more validation step to validate the nonce of the userOp --> ENtry also keeps a track so can be skipped

        // here this function is used to payabck the amount to the paymaster or the person that called the transaction to pay for the gas
        _payPreFund(_missingAccountFunds);
    }

    // The functionData is the abi encoded data that is sent to the be executed
    function execute(address _destinationAddress, uint256 _value, bytes calldata _functionData)
        external
        requireCallFromEntryPointOrOwner
    {
        (bool success, bytes memory result) = _destinationAddress.call{value: _value}(_functionData);
        require(success, MinimalAccount__FailedToExecuteCall(result));
    }

    /*/////////////////////////////////////////////////////////
    ////////////////// INTERNAL FUNCTIONS /////////////////////
    /////////////////////////////////////////////////////////*/

    // the hash is in the EIP-191 format and we need to convert it to the ETH signed message hash -> EIP-712
    // ----> This is the place where we can add a passkey
    function _validateSignature(PackedUserOperation calldata _userOp, bytes32 _userOpHash)
        internal
        view
        returns (uint256)
    {
        // in the wallet when signing we will hve converted it to the eth signed message hash format but the message userOp isnt in that format
        // even the userOpHash is not in that format so we need to convert it to that format
        // and add the needed prefix of 191 since the prefix was added during the sign but not passed in the message
        bytes32 _ethSignedMessageHash = MessageHashUtils.toEthSignedMessageHash(_userOpHash);
        address signer = ECDSA.recover(_ethSignedMessageHash, _userOp.signature);
        if (signer != owner()) {
            return SIG_VALIDATION_FAILED;
        }
        return SIG_VALIDATION_SUCCESS;
    }

    function _payPreFund(uint256 _missingAccountFunds) internal {
        if (_missingAccountFunds > 0) {
            // the funds are sent to the entryPoint contract --> Probabaly we can hardcode the address of the entrypoint contract
            (bool success,) = payable(msg.sender).call{value: _missingAccountFunds, gas: type(uint256).max}("");
            require(success, MinimalAccount__FailedTotransfer());
        }
    }

    /*/////////////////////////////////////////////////////////
    /////////////////// GETTER FUNCTIONS //////////////////////
    /////////////////////////////////////////////////////////*/
    function getEntryPoint() external view returns (address) {
        return address(i_entryPoint);
    }
}
