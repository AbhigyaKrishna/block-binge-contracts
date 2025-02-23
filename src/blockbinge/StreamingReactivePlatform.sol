// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import '../../lib/reactive-lib/src/interfaces/IReactive.sol';
import '../../lib/reactive-lib/src/abstract-base/AbstractReactive.sol';

contract StreamingReactivePlatform is IReactive, AbstractReactive {
    // Constants
    // Platform fee percentage (5% = 500)
    uint256 public constant PLATFORM_FEE = 500;
    uint256 public constant FEE_DENOMINATOR = 10000;

    uint256 private constant ADD_CONTENT_TOPIC_0 = 0xd95f18deb055f4bf7e59be05d26edef68930ea4d8c42400494548486f086c6cb;
    uint256 private constant BILL_CONTENT_TOPIC_0 = 0x57b4a7585b927028e0742f026d752ab20af68696e04f7fcb88f0b765624d5361;

    struct Content {
        uint256 id;
        address creator;
        uint256 pricePerSecond;
        uint256 flatPrice;
        string uri;
    }

    uint256 private constant SEPOLIA_CHAIN_ID = 11155111;

    uint64 private constant GAS_LIMIT = 1000000;

    mapping(uint256 => Content) public contents;

    address private _callback;

    constructor(address _service, address _contract, address callback) {
        service = ISystemContract(payable(_service));
        if (!vm) {
            service.subscribe(
                SEPOLIA_CHAIN_ID,
                _contract,
                ADD_CONTENT_TOPIC_0,
                REACTIVE_IGNORE,
                REACTIVE_IGNORE,
                REACTIVE_IGNORE
            );
            service.subscribe(
                SEPOLIA_CHAIN_ID,
                _contract,
                BILL_CONTENT_TOPIC_0,
                REACTIVE_IGNORE,
                REACTIVE_IGNORE,
                REACTIVE_IGNORE
            );
        }
        _callback = callback;
    }

    function react(LogRecord calldata log) external vmOnly {
        if (log.topic_0 == ADD_CONTENT_TOPIC_0) {
            Content memory content = abi.decode(log.data, ( Content ));
            contents[content.id] = content;
        } else if (log.topic_0 == BILL_CONTENT_TOPIC_0) {
            address user = address(uint160(log.topic_1));
            uint256 contentId = uint256(log.topic_2);
            uint256 time = uint256(log.topic_3);

            Content memory content = contents[contentId];

            // Calculate creator's share after platform fee
            uint256 amount;
            uint256 platformFeeAmount;
            uint256 creatorAmount;
            if (content.pricePerSecond > 0) {
                amount = content.pricePerSecond * time;
                platformFeeAmount = (amount * PLATFORM_FEE) / FEE_DENOMINATOR;
                creatorAmount = amount - platformFeeAmount;
            } else {
                amount = content.flatPrice;
                platformFeeAmount = (amount * PLATFORM_FEE) / FEE_DENOMINATOR;
                creatorAmount = amount - platformFeeAmount;
            }

            emit Callback(
                log.chain_id,
                _callback,
                GAS_LIMIT,
                abi.encodeWithSignature("sendPayment(address,uint256)", content.creator, creatorAmount)
            );

            emit Callback(
                log.chain_id,
                _callback,
                GAS_LIMIT,
                abi.encodeWithSignature("createPendingPayment(address,uint256)", user, amount)
            );
        }
    }
}