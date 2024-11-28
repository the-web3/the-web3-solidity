// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./bridge/TokenBridge.sol";
import "./interface/IL2PoolManager.sol";


contract L2PoolManager is TokenBridge, IL2PoolManager {
    constructor(){

    }
    
    function ClaimAllReward() external {

    }
}
