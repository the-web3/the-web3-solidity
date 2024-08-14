// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./interface/IInterfaceTest.sol";

contract InterfaceTest is IInterfaceTest {
    uint256 public data;
    constructor(){}

    function getValue() external view returns (uint256) {
        return data;
    }

    function setValue(uint256 _data) external {
        data = _data;
    }
}
