// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import '../../../lib/reactive-lib/src/interfaces/IReactive.sol';
import '../../../lib/reactive-lib/src/abstract-base/AbstractReactive.sol';

contract PaymentCalculator is IReactive, AbstractReactive {
    // Constants
    // Platform fee percentage (5% = 500)
    uint256 public constant PLATFORM_FEE = 500;
    uint256 public constant FEE_DENOMINATOR = 10000;

    uint256 private constant STREAM_PAUSED_TOPIC_0 = 0x3174d139afbcb29d1508f42509b8b84b5ad331ba22dbf220b88482c608f0ec89;
    uint256 private constant VERIFY_PAYMENT_TOPIC_0 = 0xc3e987631a4a29d4d5f7349f211a939755857def8e62217339e16c65d8b4dc2e;
    uint256 private constant BILL_TIME_TOPIC_0 = 0xe9c3ed360ef350d9f8da5bdd6ff7300b198417a5b913b2a9cf6bce0fc5bbebaa;
    
    struct PendingPayment {
        address user;
        address creator;
        uint256 amount;
        uint256 timestamp;
    }

    event SendPayment(address indexed user, uint256 indexed amount);
    event PaymentProcessed(address indexed user, uint256 indexed amount);

    uint256 private constant SEPOLIA_CHAIN_ID = 11155111;

    uint64 private constant GAS_LIMIT = 1000000;

    // State specific to reactive network instance of the contract

    // Mapping to track user balances
    mapping(address => PendingPayment[]) public pendingPaymentsByUser;

    address private _callback;

    constructor(address _service, address _contract, address callback) {
        service = ISystemContract(payable(_service));
        if (!vm) {
            service.subscribe(
                SEPOLIA_CHAIN_ID,
                _contract,
                STREAM_PAUSED_TOPIC_0,
                REACTIVE_IGNORE,
                REACTIVE_IGNORE,
                REACTIVE_IGNORE
            );
            service.subscribe(
                SEPOLIA_CHAIN_ID,
                _contract,
                VERIFY_PAYMENT_TOPIC_0,
                REACTIVE_IGNORE,
                REACTIVE_IGNORE,
                REACTIVE_IGNORE
            );
            service.subscribe(
                SEPOLIA_CHAIN_ID,
                _contract,
                BILL_TIME_TOPIC_0,
                REACTIVE_IGNORE,
                REACTIVE_IGNORE,
                REACTIVE_IGNORE
            );
        }
        _callback = callback;
    }

    mapping(address => uint256) private creatorAmounts;

    function react(LogRecord calldata log) external vmOnly {
        if (log.topic_0 == STREAM_PAUSED_TOPIC_0) {
            address _user = address(uint160(log.topic_2));
            address _creator = address(uint160(log.topic_1));
            uint256 amount = uint256(log.topic_3); // Changed to handle full uint256 value
            
            PendingPayment memory payment = PendingPayment({
                user: _user,
                creator: _creator,
                amount: amount,
                timestamp: block.timestamp
            });
            
            pendingPaymentsByUser[_user].push(payment);
        } else if (log.topic_0 == VERIFY_PAYMENT_TOPIC_0) {
            address user = address(uint160(log.topic_1));
            PendingPayment[] storage payments = pendingPaymentsByUser[user];
            require(payments.length > 0, "No pending payments");

            uint256 totalAmount;
            uint256 length = payments.length;

            // Single pass through payments to calculate amounts
            for(uint256 i; i < length; i++) {
                PendingPayment memory payment = payments[i];
                uint256 amount = payment.amount;
                totalAmount += amount;
                
                // Calculate creator's share after platform fee
                uint256 platformFeeAmount = (amount * PLATFORM_FEE) / FEE_DENOMINATOR;
                uint256 creatorAmount = amount - platformFeeAmount;
                creatorAmounts[payment.creator] += creatorAmount;
            }

            // Clear pending payments before emitting events
            delete pendingPaymentsByUser[user];

            // Emit creator payment callbacks
            for (uint256 i; i < length; i++) {
                address creator = payments[i].creator;
                uint256 amount = creatorAmounts[creator];
                delete creatorAmounts[creator];
                if (amount > 0) { // Only emit if there's an amount to pay
                    emit Callback(
                        log.chain_id,
                        _callback,
                        GAS_LIMIT,
                        abi.encodeWithSignature("sendPayment(address,uint256)", creator, amount)
                    );
                }
            }

            // Emit user payment callback
            emit Callback(
                log.chain_id,
                _callback,
                GAS_LIMIT,
                abi.encodeWithSignature("processPayment(address,uint256)", user, totalAmount)
            );
        } else if (log.topic_0 == BILL_TIME_TOPIC_0) {
            address user = address(uint160(log.topic_1));
            uint256 time = uint256(log.topic_2);
            emit Callback(
                log.chain_id,
                _callback,
                GAS_LIMIT,
                abi.encodeWithSignature("billTime(address,uint256)", user, time)
            );
        }
    }
}