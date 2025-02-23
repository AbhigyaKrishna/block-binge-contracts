// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import '../../lib/reactive-lib/src/abstract-base/AbstractCallback.sol';
import './IStreamingPlatform.sol';

contract PaymentCallback is AbstractCallback {

    IStreamingPlatform public streamingPlatform;

    constructor(address _streamingPlatform) AbstractCallback(address(0)) {
        streamingPlatform = IStreamingPlatform(_streamingPlatform);
    }

    function sendPayment(address payable user, uint256 amount) private {
        require(user.send(amount), "Transfer failed"); 
    }

    function createPendingPayment(address user, uint256 amount) private {
        streamingPlatform.addPendingPayment(user, amount);
    }

}