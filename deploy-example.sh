#!/bin/bash

export SEPOLIA_RPC=
export SEPOLIA_PRIVATE_KEY=
export REACTIVE_RPC=
export REACTIVE_PRIVATE_KEY=
export KOPLI_CALLBACK_PROXY_ADDR=
export WALLET_TOKEN=

#step-1
ORIGIN_ADDR=$(forge create --broadcast --rpc-url $SEPOLIA_RPC --private-key $SEPOLIA_PRIVATE_KEY src/blockbinge/StreamingPlatform.sol:StreamingPlatform --constructor-args $WALLET_TOKEN | sed -n 's/Deployed to: \(0x[a-fA-F0-9]\{40\}\)/\1/p')
echo "ORIGIN_ADDR: $ORIGIN_ADDR"

#step-2
CALLBACK_ADDR=$(forge create --broadcast --rpc-url $SEPOLIA_RPC --private-key $SEPOLIA_PRIVATE_KEY src/blockbinge/PaymentCallback.sol:PaymentCallback --constructor-args $ORIGIN_ADDR | sed -n 's/Deployed to: \(0x[a-fA-F0-9]\{40\}\)/\1/p')
echo "CALLBACK_ADDR: $CALLBACK_ADDR"h

#step-3
forge create --legacy --broadcast --rpc-url $REACTIVE_RPC --private-key $REACTIVE_PRIVATE_KEY src/blockbinge/PaymentCalculator.sol:PaymentCalculator --constructor-args $KOPLI_CALLBACK_PROXY_ADDR $ORIGIN_ADDR $CALLBACK_ADDR