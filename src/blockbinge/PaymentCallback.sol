// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import '../../lib/reactive-lib/src/abstract-base/AbstractCallback.sol';
import './IStreamingPlatform.sol';

contract PaymentCallback is AbstractCallback {

    // Platform wallet for collecting fees
    address public platformWallet;

    IStreamingPlatform public streamingPlatform;

    constructor(address _streamingPlatform, address _platformWallet) AbstractCallback(address(0)) {
        streamingPlatform = IStreamingPlatform(_streamingPlatform);
        platformWallet = _platformWallet;
    }

    function sendToWallet(uint256 amount) private {
        require(payable(platformWallet).send(amount), "Transfer failed");
    }

    function sendPayment(address payable user, uint256 amount) private {
        require(user.send(amount), "Transfer failed"); 
    }

    function createPendingPayment(address user, uint256 amount) private {
        streamingPlatform.addPendingPayment(user, amount);
    }

}