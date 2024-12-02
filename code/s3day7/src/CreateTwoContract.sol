// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract CreateTwoContract {
    uint256 public number;

    constructor(uint256 newNumber) {
        number = newNumber;
    }

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}
