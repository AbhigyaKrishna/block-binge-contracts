#!/bin/bash

SEPOLIA_RPC=
SEPOLIA_PRIVATE_KEY=
REACTIVE_RPC=
REACTIVE_PRIVATE_KEY=
KOPLI_CALLBACK_PROXY_ADDR=
WALLET_TOKEN=

#step-1
ORIGIN_ADDR=$(forge create --broadcast --rpc-url $SEPOLIA_RPC --private-key $SEPOLIA_PRIVATE_KEY src/blockbinge/StreamingPlatform.sol:StreamingPlatform --constructor-args $WALLET_TOKEN | sed -n 's/Deployed to: \(0x[a-fA-F0-9]\{40\}\)/\1/p')
echo "ORIGIN_ADDR: $ORIGIN_ADDR"

#step-2
CALLBACK_ADDR=$(forge create --broadcast --rpc-url $SEPOLIA_RPC --private-key $SEPOLIA_PRIVATE_KEY src/blockbinge/PaymentCallback.sol:PaymentCallback --constructor-args $ORIGIN_ADDR | sed -n 's/Deployed to: \(0x[a-fA-F0-9]\{40\}\)/\1/p')
echo "CALLBACK_ADDR: $CALLBACK_ADDR"

#step-3
REACTIVE_ADDR=$(forge create --legacy --broadcast --rpc-url $REACTIVE_RPC --private-key $REACTIVE_PRIVATE_KEY src/blockbinge/StreamingReactivePlatform.sol:StreamingReactivePlatform --constructor-args $KOPLI_CALLBACK_PROXY_ADDR $ORIGIN_ADDR $CALLBACK_ADDR | sed -n 's/Deployed to: \(0x[a-fA-F0-9]\{40\}\)/\1/p')
echo "REACTIVE_ADDR: $REACTIVE_ADDR"