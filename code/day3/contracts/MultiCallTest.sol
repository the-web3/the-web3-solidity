// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


import "hardhat/console.sol";


contract MultiCall {
    struct Call {
        address targetAddress;
        bytes  callData;
    }

    constructor() {
    }

    function multicall(Call[] memory calls) public {
        for(uint256 i = 0; i < calls.length; i++) {
            (bool success, ) = calls[i].targetAddress.call(calls[i].callData);
            require(success, "call item failed");
        }
    }
}

contract ContractA {
    uint256 public dataA;

    constructor() {
        dataA = 100;
    }

    function setDataA(uint256 _dataA) public {
        dataA = _dataA;
    }

    function getDataA() public view returns (uint256){
        return dataA;
    }
}

contract ContractB {
    uint256 public dataB;

    constructor() {
        dataB = 100;
    }

    function setDataB(uint256 _dataB) public {
        dataB = _dataB;
    }

    function getDataB() public view returns (uint256){
        return dataB;
    }
}


contract MultiCallTest {
    MultiCall public multiCall;

    constructor(address _multiCall){
        multiCall = MultiCall(_multiCall);
    }

    function setValues(address targetA, uint256 dataA, address targetB, uint256 dataB) public {
        console.log("targetA==", targetA);
        console.log("dataA==", dataA);
        console.log("targetB==", targetB);
        console.log("dataB==", dataB);
        MultiCall.Call[] memory calls = new MultiCall.Call[](2);

        calls[0] = MultiCall.Call({
            targetAddress: targetA,
            callData: abi.encodeWithSignature("setDataA(uint256)", dataA)
        });

        calls[1] = MultiCall.Call({
            targetAddress: targetB,
            callData: abi.encodeWithSignature("setDataB(uint256)", dataB)
        });
        multiCall.multicall(calls);
    }
}
