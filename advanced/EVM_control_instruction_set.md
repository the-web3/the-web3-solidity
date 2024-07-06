# EVM 控制流程，区块，Hash,  账户，交易, Log 与 Gas 相关的指令集

# 1.**控制流程指令集**

在以太坊虚拟机（EVM）中，控制流程指令用于管理程序的执行流程，包括函数调用、返回、条件分支等操作。主要的控制流程指令包括 JUMP、JUMPI、PC、JUMPDEST、CALL、CALLCODE、DELEGATECALL、STATICCALL、RETURN、REVERT、SELFDESTRUCT 等。以下是这些指令的详细介绍：

## **1.**1.无条件跳转指令 JUMP

**操作码**: 0x56

**功能**: 无条件跳转到指定的程序计数器（PC）位置。

**气体费用**: 8 gas

**操作步骤**:

- 从堆栈中弹出一个数值作为跳转目标。
- 跳转到目标位置，该位置必须是 JUMPDEST。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract JUMPExample {
    function jump(uint256 destination) public pure returns (uint256) {
        assembly {
            jump(destination)
            destination := 42 // This line will not be reached
            jumpdest
        }
        return destination;
    }
}
```

## **1.**2.条件跳转指令 JUMPI

**操作码**: 0x57

**功能**: 根据条件跳转到指定的程序计数器（PC）位置。

**气体费用**: 10 gas

**操作步骤**:

- 从堆栈中弹出一个数值作为跳转目标。
- 从堆栈中弹出一个条件数值。
- 如果条件为非零，则跳转到目标位置，该位置必须是 JUMPDEST。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract JUMPIExample {
    function conditionalJump(uint256 destination, bool condition) public pure returns (uint256) {
        uint256 result = 0;
        assembly {
            let cond := condition
            jumpi(destination, cond)
            result := 42 // This line will be reached if condition is false
            jumpdest
            result := 1 // This line will be reached if condition is true
        }
        return result;
    }
}
```

## **1.**3.程序计数器 PC

**操作码**: 0x58

**功能**: 返回当前的程序计数器（PC）位置，并将其推送到堆栈顶端。

**气体费用**: 2 gas

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PCExample {
    function getCurrentPC() public pure returns (uint256) {
        uint256 pc;
        assembly {
            pc := pc()
        }
        return pc;
    }
}
```

## **1.**4.跳转目标 JUMPDEST

**操作码**: 0x5B

**功能**: 标记一个有效的跳转目标位置。

**气体费用**: 1 gas

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract JUMPDESTExample {
    function markJumpDest() public pure returns (uint256) {
        uint256 result = 0;
        assembly {
            jumpdest
            result := 42
        }
        return result;
    }
}
```

## **1.**5.调用指令 CALL

**操作码**: 0xF1

**功能**: 调用另一个合约的方法，并传递以太币。

**气体费用**: 700 gas 基础费用 + 调用费用

**操作步骤**:

- 从堆栈中弹出 7 个数值：gas、地址、value、input data offset、input data size、output data offset、output data size。
- 调用目标合约的方法。
- 将调用结果（成功或失败）推送到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CALLExample {
    function callAnotherContract(address target, bytes memory data) public returns (bytes memory) {
        (bool success, bytes memory result) = target.call(data);
        require(success, "Call failed");
        return result;
    }
}
```

## **1.6**.静态调用指令 STATICCALL

**操作码**: 0xFA

**功能**: 调用另一个合约的方法，不允许修改状态。

**气体费用**: 700 gas 基础费用 + 调用费用

**操作步骤**:

- 从堆栈中弹出 6 个数值：gas、地址、input data offset、input data size、output data offset、output data size。
- 调用目标合约的方法（静态调用）。
- 将调用结果（成功或失败）推送到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract STATICCALLExample {
    function staticCallAnotherContract(address target, bytes memory data) public view returns (bytes memory) {
        (bool success, bytes memory result) = target.staticcall(data);
        require(success, "Static call failed");
        return result;
    }
}
```

## **1.7**.返回指令 RETURN

**操作码**: 0xF3

**功能**: 结束当前执行，并返回指定的输出数据。

**气体费用**: 0 gas

**操作步骤**:

- 从堆栈中弹出 2 个数值：output data offset、output data size。
- 返回指定的输出数据。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RETURNExample {
    function returnData() public pure returns (bytes memory) {
        bytes memory data = new bytes(32);
        assembly {
            mstore(add(data, 32), 42)
            return(add(data, 32), 32)
        }
    }
}
```

## **1.8**.回退指令 REVERT

**操作码**: 0xFD

**功能**: 终止执行，并回退所有状态更改。

**气体费用**: 0 gas

**操作步骤**:

- 从堆栈中弹出 2 个数值：revert data offset、revert data size。
- 回退状态更改，并返回指定的回退数据。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract REVERTExample {
    function revertWithData() public pure {
        bytes memory data = new bytes(32);
        assembly {
            mstore(add(data, 32), 42)
            revert(add(data, 32), 32)
        }
    }
}
```

## 1.9.自毁指令 SELFDESTRUCT

**操作码**: 0xFF

**功能**: 销毁当前合约，并将其剩余的以太币发送到指定地址。

**气体费用**: 0 gas

**操作步骤**:

- 从堆栈中弹出一个数值作为受益地址。
- 销毁当前合约，并将剩余的以太币发送到受益地址。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SELFDESTRUCTExample {
    function destroy(address payable beneficiary) public {
        selfdestruct(beneficiary);
    }
}
```

# 2. 区块相关的指令集

在以太坊虚拟机（EVM）中，区块相关的指令用于获取区块链状态信息，这些信息在智能合约的执行过程中可能是必需的。主要的区块相关指令包括 BLOCKHASH、COINBASE、TIMESTAMP、NUMBER、DIFFICULTY、GASLIMIT、CHAINID 和 BASEFEE。以下是这些指令的详细介绍：

## **2.**1.区块哈希指令 BLOCKHASH

**操作码**: 0x40

**功能**: 获取指定区块号的区块哈希。

**气体费用**: 20 gas

**操作步骤**:

- 从堆栈中弹出一个数值作为区块号。
- 推送该区块号的区块哈希到堆栈顶端（只能获取最近 256 个区块的哈希）。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlockHashExample {
    function getBlockHash(uint256 blockNumber) public view returns (bytes32) {
        bytes32 blockHash;
        assembly {
            blockHash := blockhash(blockNumber)
        }
        return blockHash;
    }
}
```

## **2.**2.挖矿奖励地址指令 COINBASE

**操作码**: 0x41

**功能**: 获取当前区块的矿工地址（coinbase）。

**气体费用**: 2 gas

**操作步骤**:

- 将当前区块的矿工地址推送到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoinbaseExample {
    function getCoinbase() public view returns (address) {
        address coinbase;
        assembly {
            coinbase := coinbase()
        }
        return coinbase;
    }
}
```

## **2.**3.区块时间戳指令 TIMESTAMP

**操作码**: 0x42

**功能**: 获取当前区块的时间戳。

**气体费用**: 2 gas

**操作步骤**:

- 将当前区块的时间戳推送到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimestampExample {
    function getTimestamp() public view returns (uint256) {
        uint256 timestamp;
        assembly {
            timestamp := timestamp()
        }
        return timestamp;
    }
}
```

## **2.**4.区块号指令 NUMBER

**操作码**: 0x43

**功能**: 获取当前区块的区块号。

**气体费用**: 2 gas

**操作步骤**:

- 将当前区块的区块号推送到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlockNumberExample {
    function getBlockNumber() public view returns (uint256) {
        uint256 blockNumber;
        assembly {
            blockNumber := number()
        }
        return blockNumber;
    }
}
```

## **2.**5.区块难度指令 DIFFICULTY

**操作码**: 0x44

**功能**: 获取当前区块的难度。

**气体费用**: 2 gas

**操作步骤**:

- 将当前区块的难度推送到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DifficultyExample {
    function getDifficulty() public view returns (uint256) {
        uint256 difficulty;
        assembly {
            difficulty := difficulty()
        }
        return difficulty;
    }
}
```

## **2.**6.区块气体限制指令 GASLIMIT

**操作码**: 0x45

**功能**: 获取当前区块的气体限制。

**气体费用**: 2 gas

**操作步骤**:

- 将当前区块的气体限制推送到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GasLimitExample {
    function getGasLimit() public view returns (uint256) {
        uint256 gasLimit;
        assembly {
            gasLimit := gaslimit()
        }
        return gasLimit;
    }
}
```

## **2.**7.链ID指令 CHAINID

**操作码**: 0x46

**功能**: 获取当前链的链ID。

**气体费用**: 2 gas

**操作步骤**:

- 将当前链的链ID推送到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ChainIDExample {
    function getChainID() public view returns (uint256) {
        uint256 chainID;
        assembly {
            chainID := chainid()
        }
        return chainID;
    }
}
```

## **2.8**.基础费用指令 BASEFEE

**操作码**: 0x48

**功能**: 获取当前区块的基础费用。

**气体费用**: 2 gas

**操作步骤**:

- 将当前区块的基础费用推送到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BaseFeeExample {
    function getBaseFee() public view returns (uint256) {
        uint256 baseFee;
        assembly {
            baseFee := basefee()
        }
        return baseFee;
    }
}
```

# 3. Hash 指令集

在以太坊虚拟机（EVM）中，Hash 指令主要用于计算各种哈希值。这些指令在智能合约中非常重要，因为它们可以用于数据的验证和保护。主要的 Hash 指令包括 SHA3。以下是这些指令的详细介绍：

## **3.**1.SHA3 指令

**操作码**: 0x20

**功能**: 计算给定内存区域的 Keccak-256 哈希值。

**气体费用**: 30 gas 基础费用 + 每个字节 6 gas

**操作步骤**:

- 从堆栈中弹出两个数值：内存区域的起始位置和内存区域的大小。
- 计算指定内存区域的 Keccak-256 哈希值。
- 将计算出的哈希值推送到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SHA3Example {
    function computeHash(bytes memory data) public pure returns (bytes32) {
        bytes32 hash;
        assembly {
            // Load the start position of the data in memory
            let dataPtr := add(data, 32)
            // Load the length of the data
            let dataLen := mload(data)
            // Compute the hash using SHA3
            hash := keccak256(dataPtr, dataLen)
        }
        return hash;
    }
}
```

示例解释

- **computeHash 函数**: 接受一个 bytes 类型的参数 data，并计算该数据的 Keccak-256 哈希值。使用内联汇编 (assembly) 直接操作内存，首先加载数据的起始位置和长度，然后调用 keccak256 指令来计算哈希值。

## **3.**2.Keccak-256 哈希

**Keccak-256** 是一种加密哈希函数，它是 SHA-3 的一种变体。EVM 使用 Keccak-256 而不是标准的 SHA-3。计算哈希时，EVM 需要消耗一定的 Gas 费用，费用与数据的大小成正比。

**用途**:

- **数据验证**: 用于验证数据的完整性。
- **唯一标识**: 用于生成数据的唯一标识符。
- **密码学**: 用于密码学操作和安全协议。

**操作步骤示例**:

- **准备数据**: 将需要哈希的数据加载到内存中。
- **调用 SHA3**: 使用 keccak256 指令计算哈希值。
- **处理结果**: 将计算出的哈希值用于进一步的操作，如验证或存储。

完整的 Solidity 合约示例

以下是一个完整的 Solidity 合约示例，演示了如何使用 SHA3 指令计算哈希值：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HashExample {
    // 计算字符串的 Keccak-256 哈希值
    function hashString(string memory input) public pure returns (bytes32) {
        bytes32 result;
        assembly {
            // 加载字符串数据的起始位置
            let inputPtr := add(input, 32)
            // 加载字符串的长度
            let inputLen := mload(input)
            // 使用 keccak256 计算哈希
            result := keccak256(inputPtr, inputLen)
        }
        return result;
    }
    
    // 计算两个整数的 Keccak-256 哈希值
    function hashIntegers(uint256 a, uint256 b) public pure returns (bytes32) {
        bytes32 result;
        assembly {
            // 分配 64 字节的内存区域
            let memPtr := mload(0x40)
            // 将整数 a 和 b 分别存储在内存中
            mstore(memPtr, a)
            mstore(add(memPtr, 32), b)
            // 使用 keccak256 计算哈希
            result := keccak256(memPtr, 64)
        }
        return result;
    }
}
```

在这个示例中，我们定义了两个函数：

- **hashString**: 接受一个字符串参数，并计算其 Keccak-256 哈希值。
- **hashIntegers**: 接受两个整数参数，并计算它们组合后的 Keccak-256 哈希值。

通过这些函数，可以看到如何在 Solidity 合约中使用 SHA3 指令来计算哈希值，并理解其在智能合约中的应用。

# 4. 账户指令集

在以太坊虚拟机（EVM）中，账户指令用于与账户相关的信息和操作。这些指令主要涉及获取账户的余额、代码、代码大小、代码哈希、地址等。主要的账户指令包括 BALANCE、EXTCODESIZE、EXTCODECOPY、EXTCODEHASH 和 SELFDESTRUCT。以下是这些指令的详细介绍：

## **4.**1.账户余额指令 BALANCE

**操作码**: 0x31

**功能**: 获取指定账户的余额。

**气体费用**: 700 gas

**操作步骤**:

- 从堆栈中弹出一个数值作为账户地址。
- 推送该账户的余额到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BalanceExample {
    function getBalance(address account) public view returns (uint256) {
        uint256 balance;
        assembly {
            balance := balance(account)
        }
        return balance;
    }
}
```

## **4.**2.外部账户代码大小指令 EXTCODESIZE

**操作码**: 0x3B

**功能**: 获取指定账户的代码大小。

**气体费用**: 700 gas

**操作步骤**:

- 从堆栈中弹出一个数值作为账户地址。
- 推送该账户的代码大小到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ExtCodeSizeExample {
    function getCodeSize(address account) public view returns (uint256) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size;
    }
}
```

## **4.**3.外部账户代码复制指令 EXTCODECOPY

**操作码**: 0x3C

**功能**: 复制指定账户的代码到内存中。

**气体费用**: 700 gas + 每字节 3 gas

**操作步骤**:

- 从堆栈中弹出 4 个数值：账户地址、内存起始位置、代码起始位置、代码大小。
- 将指定账户的代码复制到内存中。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ExtCodeCopyExample {
    function getCode(address account) public view returns (bytes memory) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        bytes memory code = new bytes(size);
        assembly {
            extcodecopy(account, add(code, 32), 0, size)
        }
        return code;
    }
}
```

## **4.**4.外部账户代码哈希指令 EXTCODEHASH

**操作码**: 0x3F

**功能**: 获取指定账户代码的 Keccak-256 哈希。

**气体费用**: 400 gas

**操作步骤**:

- 从堆栈中弹出一个数值作为账户地址。
- 推送该账户代码的 Keccak-256 哈希到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ExtCodeHashExample {
    function getCodeHash(address account) public view returns (bytes32) {
        bytes32 codehash;
        assembly {
            codehash := extcodehash(account)
        }
        return codehash;
    }
}
```

# 5. 交易指令集

在以太坊虚拟机（EVM）中，交易指令主要用于获取当前交易的信息以及执行发送以太币等操作。这些指令包括 CALL, CALLCODE, DELEGATECALL, STATICCALL, CREATE, CREATE2, CALLVALUE, CALLDATALOAD, CALLDATASIZE, CALLDATACOPY, CODESIZE, CODECOPY, 和 GASPRICE。以下是这些指令的详细介绍：

## **5.**1.交易调用指令 CALL, CALLCODE, DELEGATECALL, STATICCALL

这些指令用于调用其他合约或执行代理调用。

[**5.1.1.CALL**](https://5.1.1.call/)

操作码: 0xF1

功能: 调用另一个合约，支持发送以太币。

气体费用: 调用基本费用 + 所需 gas + 调用的子合约执行所需的 gas

操作步骤:

- 从堆栈中弹出 7 个参数：gas、目标地址、以太币数额、输入数据起始位置、输入数据大小、输出数据起始位置、输出数据大小。
- 调用指定的合约地址，传递指定的以太币和输入数据，获取输出数据。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CallExample {
    function callAnotherContract(address target, uint256 value, bytes calldata data) public returns (bytes memory) {
        (bool success, bytes memory result) = target.call{value: value}(data);
        require(success, "Call failed");
        return result;
    }
}
```

**5.1.2.CALLCODE**

操作码: 0xF2

功能: 调用另一个合约的代码，但保持当前合约的存储。

气体费用: 类似 CALL

操作步骤:

- 从堆栈中弹出 7 个参数。
- 调用指定的合约代码，但使用当前合约的存储。

**5.1.3.DELEGATECALL**

操作码: 0xF4

功能: 类似 CALLCODE，但继承调用者的 msg.sender 和 msg.value。

气体费用: 类似 CALL

操作步骤:

- 从堆栈中弹出 6 个参数：gas、目标地址、输入数据起始位置、输入数据大小、输出数据起始位置、输出数据大小。
- 调用指定的合约代码，继承调用者的 msg.sender 和 msg.value。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DelegateCallExample {
    function delegateCallAnotherContract(address target, bytes calldata data) public returns (bytes memory) {
        (bool success, bytes memory result) = target.delegatecall(data);
        require(success, "Delegate call failed");
        return result;
    }
}
```

**5.1.4.STATICCALL**

操作码: 0xFA

功能: 以静态方式调用另一个合约，不允许状态更改。

气体费用: 类似 CALL

操作步骤:

- 从堆栈中弹出 6 个参数。
- 以静态方式调用指定的合约，不允许状态更改。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StaticCallExample {
    function staticCallAnotherContract(address target, bytes calldata data) public view returns (bytes memory) {
        (bool success, bytes memory result) = target.staticcall(data);
        require(success, "Static call failed");
        return result;
    }
}
```

## 5.2.合约创建指令 CREATE, CREATE2

**5.2.1.CREATE**

操作码: 0xF0

功能: 创建一个新的合约。

气体费用: 32000 gas + 合约创建所需的 gas

操作步骤:

- 从堆栈中弹出 3 个参数：以太币数额、输入数据起始位置、输入数据大小。
- 创建新合约，并传递初始化代码。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CreateExample {
    function createNewContract(bytes memory bytecode) public returns (address) {
        address newContract;
        assembly {
            newContract := create(0, add(bytecode, 32), mload(bytecode))
        }
        require(newContract != address(0), "Contract creation failed");
        return newContract;
    }
}
```

**5.2.2.CREATE2**

操作码: 0xF5

功能: 使用指定的 salt 创建一个新的合约，确保合约地址的可预测性。

气体费用: 类似 CREATE

操作步骤:

- 从堆栈中弹出 4 个参数：以太币数额、输入数据起始位置、输入数据大小、salt。
- 创建新合约，使用 salt 生成地址。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Create2Example {
    function createNewContractWithSalt(bytes memory bytecode, bytes32 salt) public returns (address) {
        address newContract;
        assembly {
            newContract := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        require(newContract != address(0), "Contract creation failed");
        return newContract;
    }
}
```

## 5.3.交易信息指令 CALLVALUE, CALLDATALOAD, CALLDATASIZE, CALLDATACOPY

**3.1.CALLVALUE**

操作码: 0x34

功能: 获取当前调用中发送的以太币数量。

气体费用: 2 gas

操作步骤:

- 将当前调用中发送的以太币数量推送到堆栈顶端。

示例:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CallValueExample {
    function getCallValue() public payable returns (uint256) {
        uint256 value;
        assembly {
            value := callvalue()
        }
        return value;
    }
}
```

**5.3.2.CALLDATALOAD**

操作码: 0x35

功能: 从调用数据中加载一个 32 字节的值。

气体费用: 3 gas

操作步骤:

- 从堆栈中弹出一个参数：加载位置。
- 将加载的 32 字节值推送到堆栈顶端。

示例:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CallDataLoadExample {
    function loadCallData(uint256 position) public pure returns (bytes32) {
        bytes32 data;
        assembly {
            data := calldataload(position)
        }
        return data;
    }
}
```

**5.3.3.CALLDATASIZE**

操作码: 0x36

功能: 获取调用数据的大小。

气体费用: 2 gas

操作步骤:

- 将调用数据的大小推送到堆栈顶端。

示例:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CallDataSizeExample {
    function getCallDataSize() public pure returns (uint256) {
        uint256 size;
        assembly {
            size := calldatasize()
        }
        return size;
    }
}
```

**5.3.4.CALLDATACOPY**

操作码: 0x37

功能: 将调用数据复制到内存中。

气体费用: 3 gas + 每字节 3 gas

操作步骤:

- 从堆栈中弹出 3 个参数：内存起始位置、数据起始位置、数据大小。
- 将调用数据复制到内存中。

示例:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CallDataCopyExample {
    function copyCallData(uint256 start, uint256 length) public pure returns (bytes memory) {
        bytes memory data = new bytes(length);
        assembly {
            calldatacopy(add(data, 32), start, length)
        }
        return data;
    }
}
```

## 5.4.合约代码指令 CODESIZE, CODECOPY

**5.4.1.CODESIZE**

**操作码**: 0x38

**功能**: 获取当前合约的代码大小。

**气体费用**: 2 gas

**操作步骤**:

- 将当前合约的代码大小推送到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CodeSizeExample {
    function getCodeSize() public view returns (uint256) {
        uint256 size;
        assembly {
            size := codesize()
        }
        return size;
    }
}
```

**5.4.2.CODECOPY**

操作码: 0x39

功能: 将当前合约的代码复制到内存中。

气体费用: 3 gas + 每字节 3 gas

操作步骤:

- 从堆栈中弹出 3 个参数：内存起始位置、代码起始位置、代码大小。
- 将当前合约的代码复制到内存中。

示例:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CodeCopyExample {
    function copyCode(uint256 start, uint256 length) public view returns (bytes memory) {
        bytes memory code = new bytes(length);
        assembly {
            codecopy(add(code, 32), start, length)
        }
        return code;
    }
}
```

## 5.5.获取当前 Gas 价格 GASPRICE

**操作码**: 0x3A

**功能**: 获取当前交易的 gas 价格。

**气体费用**: 2 gas

**操作步骤**:

- 将当前交易的 gas 价格推送到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GasPriceExample {
    function getGasPrice() public view returns (uint256) {
        uint256 gasPrice;
        assembly {
            gasPrice := gasprice()
        }
        return gasPrice;
    }
}
```

## 5.6.完整示例

以下是一个综合使用上述指令的完整示例合约：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EVMSample {

    function callExample(address target, uint256 value, bytes calldata data) public returns (bytes memory) {
        (bool success, bytes memory result) = target.call{value: value}(data);
        require(success, "Call failed");
        return result;
    }

    function delegateCallExample(address target, bytes calldata data) public returns (bytes memory) {
        (bool success, bytes memory result) = target.delegatecall(data);
        require(success, "Delegate call failed");
        return result;
    }

    function staticCallExample(address target, bytes calldata data) public view returns (bytes memory) {
        (bool success, bytes memory result) = target.staticcall(data);
        require(success, "Static call failed");
        return result;
    }

    function createExample(bytes memory bytecode) public returns (address) {
        address newContract;
        assembly {
            newContract := create(0, add(bytecode, 32), mload(bytecode))
        }
        require(newContract != address(0), "Contract creation failed");
        return newContract;
    }

    function create2Example(bytes memory bytecode, bytes32 salt) public returns (address) {
        address newContract;
        assembly {
            newContract := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        require(newContract != address(0), "Contract creation failed");
        return newContract;
    }

    function getCallValue() public payable returns (uint256) {
        uint256 value;
        assembly {
            value := callvalue()
        }
        return value;
    }

    function loadCallData(uint256 position) public pure returns (bytes32) {
        bytes32 data;
        assembly {
            data := calldataload(position)
        }
        return data;
    }

    function getCallDataSize() public pure returns (uint256) {
        uint256 size;
        assembly {
            size := calldatasize()
        }
        return size;
    }

    function copyCallData(uint256 start, uint256 length) public pure returns (bytes memory) {
        bytes memory data = new bytes(length);
        assembly {
            calldatacopy(add(data, 32), start, length)
        }
        return data;
    }

    function getCodeSize() public view returns (uint256) {
        uint256 size;
        assembly {
            size := codesize()
        }
        return size;
    }

    function copyCode(uint256 start, uint256 length) public view returns (bytes memory) {
        bytes memory code = new bytes(length);
        assembly {
            codecopy(add(code, 32), start, length)
        }
        return code;
    }

    function getGasPrice() public view returns (uint256) {
        uint256 gasPrice;
        assembly {
            gasPrice := gasprice()
        }
        return gasPrice;
    }
}
```

这个合约演示了如何使用各种 EVM 交易指令来进行合约调用、创建、数据加载和复制、获取交易信息等操作。每个函数对应一个具体的指令，展示了其实际应用和返回结果。

# 6. Log 指令集

在以太坊虚拟机（EVM）中，Log 指令用于向区块链中写入日志数据。日志数据可以在以太坊客户端（如以太坊节点或区块浏览器）中查看，并且在 Solidity 合约中使用事件（event）来定义和触发日志记录。以下是与 Log 相关的 EVM 指令及其详细介绍：

## **6.**1.LOG0, LOG1, LOG2, LOG3, LOG4 指令

**功能**: 将日志数据写入区块链。

**操作码**:

- LOG0: 0xA0
- LOG1: 0xA1
- LOG2: 0xA2
- LOG3: 0xA3
- LOG4: 0xA4

**气体费用**: 375 gas + 8 gas/byte

**操作步骤**:

- LOG0 至 LOG4 指令从堆栈中弹出若干个参数，将日志数据写入区块链。
- 每个 LOG 指令都需要以下参数： 日志主题（topic）数量 日志主题（topic）数组起始位置 日志数据起始位置 日志数据大小

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LogExample {
    event LogEvent(address indexed sender, uint256 indexed value);

    function logData(uint256 value) public {
        emit LogEvent(msg.sender, value);
    }
}
```

- 在上面的示例中，LogExample 合约定义了一个事件 LogEvent，用于记录发送者地址和值。
- emit LogEvent(msg.sender, value) 语句将触发日志记录。当函数 logData 被调用时，会在区块链上写入相应的日志数据。
- Solidity 会自动为事件生成日志主题（topic），例如 msg.sender 和 value。

## 6.2.使用日志的优势

- **数据记录**: 日志可以用来记录合约执行过程中的重要事件和数据变化。
- **可审计性**: 日志是智能合约的一种审计和调试工具，可以帮助开发者和用户了解合约的行为和状态变化。
- **事件通知**: 客户端应用程序可以通过订阅合约事件来获取即时通知和更新。

# 7. Gas 指令集

在以太坊虚拟机（EVM）中，Gas 指令主要用于管理和获取当前交易的 gas 相关信息。以下是与 gas 相关的主要指令及其详细介绍：

## 7.1.GAS 指令

**操作码**: 0x5A

**功能**: 返回剩余的 gas。

**气体费用**: 2 gas

**操作步骤**:

- 将当前执行上下文中剩余的 gas 推送到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GasExample {
    function getRemainingGas() public view returns (uint256) {
        uint256 gasRemaining;
        assembly {
            gasRemaining := gas()
        }
        return gasRemaining;
    }
}
```

## 7.2.GASLIMIT 指令

**操作码**: 0x45

**功能**: 获取当前区块的 gas 限制。

**气体费用**: 2 gas

**操作步骤**:

- 将当前区块的 gas 限制推送到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GasLimitExample {
    function getGasLimit() public view returns (uint256) {
        uint256 gasLimit;
        assembly {
            gasLimit := gaslimit()
        }
        return gasLimit;
    }
}
```

## 7.3.GASPRICE 指令

**操作码**: 0x3A

**功能**: 获取当前交易的 gas 价格。

**气体费用**: 2 gas

**操作步骤**:

- 将当前交易的 gas 价格推送到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GasPriceExample {
    function getGasPrice() public view returns (uint256) {
        uint256 gasPrice;
        assembly {
            gasPrice := gasprice()
        }
        return gasPrice;
    }
}
```

## 7.4.GAS 指令的应用

在智能合约中，开发者可以使用 gas() 指令来获取当前剩余的 gas，并使用 gaslimit() 和 gasprice() 指令来获取当前区块的 gas 限制和交易的 gas 价格。这些信息对于优化合约性能和管理 gas 成本非常重要。

## 7.5.组合示例

以下是一个综合使用 gas 指令的合约示例，展示了如何在合约中获取并显示当前交易和区块的 gas 信息：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GasInfo {
    function getGasInfo() public view returns (uint256, uint256, uint256) {
        uint256 gasRemaining;
        uint256 gasLimit;
        uint256 gasPrice;

        assembly {
            gasRemaining := gas()
            gasLimit := gaslimit()
            gasPrice := gasprice()
        }

        return (gasRemaining, gasLimit, gasPrice);
    }
}
```

- getGasInfo 函数同时返回当前剩余的 gas、当前区块的 gas 限制和当前交易的 gas 价格。
- 使用 assembly 块来调用 EVM 的 gas、gaslimit 和 gasprice 指令。