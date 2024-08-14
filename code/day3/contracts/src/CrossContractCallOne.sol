// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../interface/ICrossContractCallOne.sol";
import "../interface/ICrossContractCall.sol";

/*
 * tx.origin: 是合约调用链的最初一个账户
 * msg.sender: 代表当前 call 合约的账户
 * address(this): 当前合约地址
*/

contract CrossContractCallOne is ICrossContractCallOne {
    ICrossContractCall public ccCall;

    constructor(ICrossContractCall _ccCall){
        ccCall = _ccCall;
    }

    function addResult() external  returns (uint256) {
        return ccCall.addTwo(100, 200);
    }

    function addThree() external returns (uint256) {
        return ccCall.addThree(100, 200, 1000);
    }

}
