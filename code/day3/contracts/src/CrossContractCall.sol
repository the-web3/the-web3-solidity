// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../interface/ICrossContractCall.sol";

contract CrossContractCall is ICrossContractCall {
    uint256 public result;

    constructor() {
        result = 0;
    }

    function addTwo(uint256 valueOne, uint256 valueTwo) external returns (uint256) {
        result = valueOne + valueTwo;
        return result;
    }

    function addThree(uint256 valueOne, uint256 valueTwo, uint256 valueThree) external returns (uint256) {
        result = valueOne + valueTwo + valueThree;
        return result;
    }
}
