// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


/* EOA 和合约地址
 * public: 修饰函数或者状态变量时，其他合约和外部账户都是可以访问，对于函数而言，可以被合约内外调用，对于状态变量，可以被合约内部读取
 * external: 修饰函数只能被外部账户和合约调用，，就是只能从合约外部进行访问
 * internal:修饰函数或者状态变量只能被当前合约及其派生合约访问
 * private: 修饰函数或者状态变量只能被当前合约访问，即使是派生合约也不能访问
*/

/*
 * view: 不会修改合约状态，但是可以读取合约状状态变量，可以调用其他由 view 和 pure 修饰函数，但是不允许修改状态变量，不允许发送 Eth
 * pure: 不读取，也不修改
 * payable: 修饰接收 ETH 支付函数，可以调用其他 payable 的函数，可以读取合约状态变量（view 和 pure）, 不能修改状态变量（view）
 * virtual: 虚函数，声明的函数可以被派生合约重写（覆盖），派生合约中可以使用 override 关键字重新 virtual 函数，virtual 函数也可以由默认实现，也可以是纯虚函数，只声明，不实现
 */


contract FunctionEvent {
    uint256 public data;

    constructor(){

    }

    function setData(uint256 _data) external {
        data = _data;
    }

    function getData() internal view returns (uint256) {
        return data;
    }

    function add(uint256 a, uint256 b) external view returns (uint256) {
        return a + b;
    }

    function getValue() public virtual returns (uint256) {
        return 10;
    }
}


contract FunctionEventInherit is FunctionEvent {
    constructor(){
    }

    function getDataInherit() internal view returns (uint256) {
        return getData();
    }

    function getDataInheritAAA() external view returns (uint256) {
        return getDataInherit();
    }

    function getValue() public view override returns (uint256) {
        return 100;
    }

    function foo(uint256 _value) public view returns (uint256) {
        return _value;
    }

    function foo(string memory _text) public  view returns (string memory) {
        return _text;
    }

    function foo(uint256 _value, uint256 _value2) public view returns (uint256) {
        return _value + _value2;
    }
}



