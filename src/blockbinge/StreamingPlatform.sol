// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./IStreamingPlatform.sol";

contract StreamingPlatform is IStreamingPlatform {
    
    // Content ID => User Address => Stream session
    mapping(address => mapping(uint256 => uint256)) public totalWatchTime;
    mapping(address => uint256) public pendingPayments;
    
    // Next content ID
    uint256 private nextContentId;
    
    event AddContent(uint256 id, address creator, uint256 pricePerSecond, uint256 flatPrice, string uri);
    // event ContentAdded(uint256 indexed contentId, address indexed creator, uint256 pricePerSecond, uint256 flatPrice);
    // event StreamStarted(uint256 indexed contentId, address indexed user, uint256 startTime);
    // event StreamPaused(uint256 contentId, address indexed creator, address indexed user, uint256 endTime, uint256 indexed amountPaid);
    // event VerifyPayment(address indexed user);
    event BillContent(address indexed user, uint256 contentId, uint256 indexed time);
    
    function addContent(
        uint256 _pricePerSecond,
        uint256 _flatPrice,
        string calldata _contentUri
    ) external returns (uint256) {
        require(_pricePerSecond > 0 || _flatPrice > 0, "Invalid pricing");
        
        uint256 contentId = nextContentId++;
        // content[contentId] = Content({
        //     creator: msg.sender,
        //     pricePerSecond: _pricePerSecond,
        //     flatPrice: _flatPrice,
        //     isActive: true,
        //     contentUri: _contentUri
        // });
        
        // emit ContentAdded(contentId, msg.sender, _pricePerSecond, _flatPrice);
        // return contentId;
        emit AddContent(contentId, msg.sender, _pricePerSecond, _flatPrice, _contentUri);
        return contentId;
    }
    
    // function startStream(uint256 _contentId) external {
    //     Content storage contentData = content[_contentId];
    //     require(contentData.isActive, "Content not available");
        
    //     StreamSession storage session = streamSessions[_contentId][msg.sender];
    //     require(!session.isActive, "Stream already active");
        
    //     session.startTime = block.timestamp;
    //     session.lastUpdateTime = block.timestamp;
    //     session.isActive = true;
        
    //     emit StreamStarted(_contentId, msg.sender, block.timestamp);
    // }
    
    // function pauseStream(uint256 _contentId) external {
    //     StreamSession storage session = streamSessions[_contentId][msg.sender];
    //     require(session.isActive, "Stream not active");
        
    //     Content storage contentData = content[_contentId];
        
    //     if (contentData.pricePerSecond > 0) {
    //         uint256 duration = block.timestamp - session.lastUpdateTime;
    //         uint256 amount = duration * contentData.pricePerSecond;
            
    //         session.totalPaid += amount;
    //     }
        
    //     uint256 totalPaid = session.totalPaid;
    //     delete streamSessions[_contentId][msg.sender];
    //     emit StreamPaused(_contentId, content[_contentId].creator, msg.sender, block.timestamp, totalPaid);
    // }
    
    // function getContentUri(uint256 _contentId) external view returns (string memory) {
    //     require(content[_contentId].isActive, "Content not available");
    //     return content[_contentId].contentUri;
    // }
    
    // function getStreamSession(uint256 _contentId, address user) 
    //     external 
    //     view 
    //     returns (
    //         uint256 startTime,
    //         uint256 lastUpdateTime,
    //         bool isActive,
    //         uint256 totalPaid
    //     ) 
    // {
    //     StreamSession memory session = streamSessions[_contentId][user];
    //     return (
    //         session.startTime,
    //         session.lastUpdateTime,
    //         session.isActive,
    //         session.totalPaid
    //     );
    // }

    // Add function to get content pricing
    // function getContentPricing(uint256 contentId) external view returns (
    //     uint256 pricePerSecond,
    //     uint256 flatPrice,
    //     bool isActive
    // ) {
    //     Content memory contentData = content[contentId];
    //     return (
    //         contentData.pricePerSecond,
    //         contentData.flatPrice,
    //         contentData.isActive
    //     );
    // }

    // function getContentCreator(uint256 contentId) external view returns (address creator) {
    //     return content[contentId].creator;
    // }

    function getTotalWatchTime(address user, uint256 contentId) external view returns (uint256) {
        return totalWatchTime[user][contentId];
    }

    function addPendingPayment(address user, uint256 amount) external {
        require(amount > 0, "Payment amount must be greater than 0");
        pendingPayments[user] += amount;
    }

    function verifyPayment() external payable {
        require(pendingPayments[msg.sender] > 0, "No pending payments");
        require(msg.value == pendingPayments[msg.sender], "Payment amount must match the requested amount");

        delete pendingPayments[msg.sender];
    }

    function billSession(uint256 contentId, uint256 time) external {
        totalWatchTime[msg.sender][contentId] += time;

        emit BillContent(msg.sender, contentId, time);
    }

} 
