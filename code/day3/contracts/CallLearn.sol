// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;


import "hardhat/console.sol";

/*
 * tx.origin: 是合约调用链的最初一个账户
 * msg.sender: 代表当前 call 合约的账户
 * address(this): 当前合约地址
*/

contract TargetContract {
    uint256 public data;

    constructor() {
        data = 100;
    }

    function setData(uint256 _data) public {
         console.log("tx.origin==", tx.origin);
         console.log("msg.sender==", msg.sender);
         console.log("address this==", address(this));
         data = _data;
    }

    function getData() public view returns (uint256){
        return data;
    }
}


contract CallLearn {
    function callSetData(address _targetAddress, uint256 _data) public {
        (bool success, bytes memory dataByte) = _targetAddress.call(
            abi.encodeWithSignature("setData(uint256)", _data)
        );
        require(success, "call target contracts failed");
    }
}
