// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract BaseOne {
    uint256 public dataOne;

    function setDataOne(uint256 _dataOne) public {
        dataOne = _dataOne;
    }

    function getDataOne() public view returns (uint256)  {
        return dataOne;
    }
}

contract BaseTwo {
    uint256 public dataTwo;

    constructor(uint256 _dataTwo){
        dataTwo = _dataTwo;
    }

    function setDataTwo(uint256 _dataTwo) public {
        dataTwo = _dataTwo;
    }

    function getDataTwo(uint256 _dataTwo) public view returns (bool)  {
        return dataTwo == _dataTwo;
    }
}

contract BaseInherit is BaseOne, BaseTwo {
    uint256 public dataBase;

    constructor(uint256 _data) BaseTwo(_data) {}

}
