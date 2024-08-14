// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./lib/SafeCall.sol";

contract SafeTarget {
    uint256 public data;

    constructor() {
        data = 50;
    }

    function setData(uint256 _data) public {
        data = _data;
    }

    function getData() public view returns (uint256){
        return data;
    }
}

contract SafeTest {
    address public immutable owner;
    uint256 public constant GasLimit = 21000;

    constructor(){
        owner = msg.sender;
    }


    function safeCallTest(address targetAddress, uint256 data) public  {
       bool success =  SafeCall.callWithMinGas(
            targetAddress,
            GasLimit,
            0,
            abi.encodeWithSignature(
                "setData(uint256)",
                data
            )
        );
       require(success, "safe call test failed");
    }
}
