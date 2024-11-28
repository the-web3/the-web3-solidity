// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./bridge/TokenBridge.sol";
import "./interface/IL1PoolManager.sol";

contract L1PoolManager is TokenBridge, IL1PoolManager {
    constructor(){

    }

    // ----------------------------------全局变量-----------------------------------------------
    // 示范：msg.send, tx.origin, block.timestamp
    // 不需要定义直接取用
    // ----------------------------------全局变量-----------------------------------------------


    // ----------------------------------状态变量-----------------------------------------------
    uint256 public l1Amount;
    // 生命周期：和合约的生命周期是一致，在区块链中永久存储
    // 状态变量修改：消耗 gas
    // 不管是什么修饰符修饰：在本合约内全局可以访问
    // ----------------------------------状态变量-----------------------------------------------


    function DepositAndStakingERC20(address _token, uint256 _amount) external {
        // ----------------------------------局部变量-----------------------------------------------
        // 在函数里面定义的变量，仅在函数调用期间存在，存储在内存
        // - 不存储区块链中，修改不消耗 gas
        // - 生命周期仅限于函数执行周期
        // - 不能生成 public 或者 external
        // ----------------------------------局部变量-----------------------------------------------

    }

    // storage, memory, call
    // ----------------------------------storage-----------------------------------------------
    // storage 修饰的变量永久存在区块链
    // 适用场景
    // - 状态变量
    // - 显示存储到 storage 里面的临时变量
    // 特性
    // - 持久化存储，修改需要消耗 gas
    // - 默认情况下，状态变量就是存储在 storage 里面
    //
    // ----------------------------------storage-----------------------------------------------

    // ----------------------------------memory-----------------------------------------------
    // memory 临时存储在内存中的变量，仅在函数调用期间存储
    // 适用场景
    // - 函数内部的局部变量
    // - 传递复杂的数据类似（例如：结构体和数组）
    // 特性
    // - 生命周期短，修改不需要消耗 gas
    // - 显示使用 memory 关键字声明
    // ----------------------------------memory-----------------------------------------------

    // ----------------------------------callData-----------------------------------------------
    // calldata: 专用于 external 函数输入参数，存储在调用数据
    // 适用场景
    // - 接收外部函数的参数
    // 特性
    // - 不可以修改，只读特性
    // - 用于优化 gas
    // ----------------------------------callData-----------------------------------------------

    // ----------------------------------stack-----------------------------------------------
    // 后进先出
    // EVM 栈深度：1024 slot = 32 byte
    //
    // ----------------------------------stack-----------------------------------------------

    function complexFunction(uint a, uint b, uint c, uint d, uint e, uint f, uint g) public pure {
        uint h = a + b + c + d + e + f + g + a + b + c + d + e + f + g;
    }

    function calculate(uint a, uint b) public pure returns (uint) {
        return (a + b) * 2;
    }
    /*
    *  PUSH1 将 a 压入栈。
    *  PUSH1 将 b 压入栈。
    *  ADD 弹出 a 和 b, 将加法结果压栈
    *  PUSH1 将 2 压入栈。
    *  MUL 弹出结果和 2，计算并将最终结果压入栈。
    */

    // 1 slot = 32 字节
    // uint256 256 位 32 字节
    // uint8   8 位   1 字节
    // string：动态的, 取决字符串长度
    // bool: 8 位 1 字节
    // address: 20 字节

    struct AAA {
        uint256 a; // 1 slot
        uint8 b;   // 2 slot
        uint8 c;   // 2 slot
    }

    struct BBB {
        uint8 b;   // 1 slot
        uint256 a; // 2 slot
        uint8 c;   // 3 slot
        uint256 d; // 4 slot
        uint256 e; // 5 slot
        uint256 f; // 5 slot
    }

    uint256 public ccc; // 1 slot

    mapping(uint256 => BBB) CCC; // 2 slot

    BBB ccc;

    uint256 public sss; // 3slot

    uint256 public eeeee;   // 4 slot

    uint256 []ABCDE;

    uint256[] public arr;

    constructor() {
        arr.push(10);
        arr.push(20);
        arr.push(30);
    }

    // 0x00 - 0x3f （64字节）：用于哈希方法的临时空间，比如读取mapping里的数据时，要用到key的hash值，key的hash结果就暂存在这里。
    // 0x40 - 0x5f （32字节）：当前分配的内存大小，又称空闲内存指针，指向当前空闲的内存位置。Solidity 总会把新对象保存在空闲内存指针的位置，并更新它的值到下一个空闲位置。
    // 0x60 - 0x7f （32字节）： 32字节的0值插槽，用于需要零值的地方，比如动态长度数据的初始长度
    // - Slot 0：存储数组长度（3）
    // - Slot keccak256(0)：存储 arr[0]（10）
    // -  Slot keccak256(0) + 1：存储 arr[1]（20）
    // - Slot keccak256(0) + 2：存储 arr[2]（30）

    function DepositAndStakingETH() external payable {

    }
}
