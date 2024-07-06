# EVM 内存与存储指令集

# 1.**内存指令集**

在以太坊虚拟机（EVM）中，内存指令用于管理和操作临时数据存储。内存是可变的、字节可寻址的区域，用于智能合约在执行过程中存储数据。主要的内存指令包括 MLOAD、MSTORE、MSTORE8 以及与内存相关的其他指令。以下是这些指令的详细介绍：

## 1.1.内存加载指令 MLOAD

**操作码**: 0x51

**功能**: 从指定的内存地址读取 32 字节（256 位）的数据，并将其推送到堆栈顶端。

**气体费用**: 3 gas

**操作步骤**:

- 从堆栈中弹出一个 256 位数值作为内存地址。
- 从该地址读取 32 字节的数据。
- 将读取的数据推送到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MLOADExample {
    function loadFromMemory(uint256 offset) public pure returns (bytes32) {
        bytes32 result;
        assembly {
            result := mload(offset)
        }
        return result;
    }
}
```

## **1.**2.内存存储指令 MSTORE

**操作码**: 0x52

**功能**: 将 32 字节（256 位）的数据存储到指定的内存地址。

**气体费用**: 3 gas

**操作步骤**:

- 从堆栈中弹出一个 256 位数值作为内存地址。
- 从堆栈中弹出一个 256 位数值作为要存储的数据。
- 将数据存储到指定的内存地址。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MSTOREExample {
    function storeToMemory(uint256 offset, bytes32 value) public pure {
        assembly {
            mstore(offset, value)
        }
    }
}
```

## **1.**3.内存存储指令（8 位） MSTORE8

**操作码**: 0x53

**功能**: 将一个字节（8 位）的数据存储到指定的内存地址。

**气体费用**: 3 gas

**操作步骤**:

- 从堆栈中弹出一个 256 位数值作为内存地址。
- 从堆栈中弹出一个 256 位数值，并取其最低的 8 位作为要存储的数据。
- 将数据存储到指定的内存地址。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MSTORE8Example {
    function storeByteToMemory(uint256 offset, uint8 value) public pure {
        assembly {
            mstore8(offset, value)
        }
    }
}
```

## **1.**4.内存大小指令 MSIZE

**操作码**: 0x59

**功能**: 返回当前分配的内存大小，以字节为单位。内存大小总是 32 字节的倍数。

**气体费用**: 2 gas

**操作步骤**:

- 将当前分配的内存大小推送到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MSIZEExample {
    function getMemorySize() public pure returns (uint256) {
        uint256 size;
        assembly {
            size := msize()
        }
        return size;
    }
}
```

## **1.**5.清零指令 MCLEAR

虽然没有直接的 MCLEAR 指令，内存可以通过将数据存储为零来清零。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ClearMemoryExample {
    function clearMemory(uint256 offset) public pure {
        assembly {
            mstore(offset, 0)
        }
    }
}
```

# 2.**存储指令集**

在以太坊虚拟机（EVM）中，存储指令用于管理和操作合约的持久化存储。存储是一个键值对映射，用于在合约执行过程中保存状态。主要的存储指令包括 SLOAD 和 SSTORE。以下是这些指令的详细介绍：

## 2.1.存储加载指令 SLOAD

**操作码**: 0x54

**功能**: 从存储中读取一个 32 字节（256 位）的数据，并将其推送到堆栈顶端。

**气体费用**:

- 冷存储槽: 2100 gas
- 热存储槽: 100 gas

**操作步骤**:

- 从堆栈中弹出一个 256 位数值作为存储地址。
- 从该地址读取 32 字节的数据。
- 将读取的数据推送到堆栈顶端。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SLOADExample {
    mapping(uint256 => uint256) private store;

    function setStorage(uint256 key, uint256 value) public {
        store[key] = value;
    }

    function loadFromStorage(uint256 key) public view returns (uint256) {
        uint256 result;
        assembly {
            result := sload(key)
        }
        return result;
    }
}
```

## **2.**2.存储存储指令 SSTORE

**操作码**: 0x55

**功能**: 将 32 字节（256 位）的数据存储到指定的存储地址。

**气体费用**:

- 设置为非零值：20000 gas
- 从非零值更改：2900 gas
- 从非零值改为零值：5000 gas

**操作步骤**:

- 从堆栈中弹出一个 256 位数值作为存储地址。
- 从堆栈中弹出一个 256 位数值作为要存储的数据。
- 将数据存储到指定的存储地址。

**示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SSTOREExample {
    function storeToStorage(uint256 key, uint256 value) public {
        assembly {
            sstore(key, value)
        }
    }

    function loadFromStorage(uint256 key) public view returns (uint256) {
        uint256 result;
        assembly {
            result := sload(key)
        }
        return result;
    }
}
```

## **2.**3.其他存储相关注意事项

- **持久性**: 合约的存储是持久的，意味着在合约调用之间数据保持不变。
- **成本**: 存储操作（尤其是 SSTORE）的成本较高，因为它们会影响到整个区块链的状态。使用 SLOAD 时注意冷存储槽和热存储槽的气体费用差异。
- **安全性**: 由于存储是合约的持久状态，确保对存储的访问和修改受到严格控制，以防止意外的数据丢失或篡改。