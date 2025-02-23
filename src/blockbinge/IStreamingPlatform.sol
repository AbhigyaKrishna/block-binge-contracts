// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IStreamingPlatform {
    function addContent(
        uint256 _pricePerSecond,
        uint256 _flatPrice,
        string calldata _contentUri
    ) external returns (uint256);
    
    // function startStream(uint256 _contentId) external;
    
    // function pauseStream(uint256 _contentId) external;
    
    // function getContentUri(uint256 _contentId) external view returns (string memory);
    
    // function getStreamSession(uint256 _contentId, address user)
    //     external
    //     view
    //     returns (
    //         uint256 startTime,
    //         uint256 lastUpdateTime,
    //         bool isActive,
    //         uint256 totalPaid
    //     );
    
    // function getContentPricing(uint256 contentId) external view returns (
    //     uint256 pricePerSecond,
    //     uint256 flatPrice,
    //     bool isActive
    // );

    // function getContentCreator(uint256 contentId) external view returns (address creator);

    function getTotalWatchTime(address user, uint256 contentId) external view returns (uint256);

    function addPendingPayment(address user, uint256 amount) external;

    function verifyPayment() external payable;

    function billSession(uint256 contentId, uint256 time) external;
} 