// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract BaseOne {
    uint256 public dataA;

    constructor(){
    }

    function setDataA(uint256 _data) public {
        dataA = _data;
    }

    function getDataA() public view returns (uint256) {
        return dataA;
    }
}

contract BaseTwo {
    uint256 public dataB;

    constructor(uint256 _data){
        dataB = _data;
    }

    function setDataB(uint256 _data) public {
        dataB = _data;
    }

    function getDataB() public view returns (uint256) {
        return dataB;
    }
}

contract Inherit is BaseOne, BaseTwo {
    constructor(uint256 _data) BaseTwo(_data) {
    }

    function setData(uint256 _dataA, uint256 _dataB) public {
        setDataA(_dataA);
        setDataB(_dataB);
    }

    function getData() public view returns (uint256, uint256) {
        return(getDataA(), getDataB());
    }
}

