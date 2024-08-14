// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IInterfaceTest {
    function getValue() external view returns (uint256);
    function setValue(uint256 _data) external;
}
