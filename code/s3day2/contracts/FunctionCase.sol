// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import "hardhat/console.sol";

/*
 * 合约事件：消耗 gas
 * 当你修改合约的状态变量的时候，需要抛出一个事件
 * 当发生资金转移的时候，需要抛出一个事件
 * 根据业务场景来抛出事件
*/

contract Function  {
    uint256 public stateVar;   // stateVar()(uint256)

    event eventName(uint256 result);

    // 默认有一个构造函数
    function setStateVar(uint256 _stateVar) public {
        stateVar = _stateVar;
    }

    function getStateVar() public view returns(uint256) {
        return stateVar;
    }

    function getValue() public pure returns(uint256) {
        return 10;
    }

    function add(uint256 a, uint256 b) public returns(uint256) {
        uint256 result = a + b;
        emit eventName(result);
        return result;
    }
}

contract FunctionCase is Function {
    function getInheritValue() public view returns(uint256) {
        return getValue();
    }

    function getInheritStateVar() public view returns(uint256) {
        return stateVar;
    }

    function updateStateVar(uint256 _stateVar) public {
        stateVar = _stateVar;
    }
}


