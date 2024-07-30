// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface ICrossContractCall {
    function addTwo(uint256 valueOne, uint256 valueTwo) external returns (uint256);
    function addThree(uint256 valueOne, uint256 valueTwo, uint256 valueThree) external returns (uint256);
}
