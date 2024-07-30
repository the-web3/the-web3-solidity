// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


contract TargetDelegateCallContract {
    uint256 public data;

    constructor() {
        data = 100;
    }

    function setData(uint256 _data) public {
        data = _data;
    }

    function getData() public view returns (uint256){
        return data;
    }
}

contract DelegateCallTest {
    uint256 public data;

    function delegateCallSetData(address _targetAddress, uint256 _data) public {
        (bool success, ) = _targetAddress.delegatecall(
            abi.encodeWithSignature("setData(uint256)", _data)
        );
        require(success, "call target detegate call contracts failed");
    }
}
