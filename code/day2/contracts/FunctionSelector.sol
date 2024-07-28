// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract FunctionSelector {
    uint256 public value;

    function setValue(uint256 _value) public {
        value = _value;
    }
}


contract FunctionSelectorItem {
    FunctionSelector public functionSelector;


    event CallSetValue(
        address indexed sender,
        uint256 _value
    );

    constructor(address _functionSelector) {
        functionSelector = FunctionSelector(_functionSelector);
    }

    function callSetValue(uint256 _value) public {
        emit CallSetValue(msg.sender, _value);
        functionSelector.setValue(_value);
    }

    function getSetValueSelector() public view returns(bytes4) {
        return functionSelector.setValue.selector;
    }
}
