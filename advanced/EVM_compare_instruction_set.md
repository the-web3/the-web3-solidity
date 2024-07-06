# EVM 比较指令集

在以太坊虚拟机（EVM）中，比较运算符用于比较堆栈上的数值，并返回布尔结果（0 或 1）。以下是详细介绍 EVM 中的比较运算符指令，包括 LT、GT、SLT、SGT、EQ 和 ISZERO。

# 1.小于指令 LT

- **操作码**: 0x10
- **功能**: 比较堆栈顶端的第二个数值是否小于堆栈顶端的第一个数值。如果是，将 1 推送到堆栈顶端；否则，推送 0。
- **气体费用**: 3 gas
- **示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LTExample {
    function lessThan(uint256 a, uint256 b) public pure returns (bool) {
        bool result;
        assembly {
            result := lt(a, b)
        }
        return result;
    }
}
```

## 2.大于指令 GT

- **操作码**: 0x11
- **功能**: 比较堆栈顶端的第二个数值是否大于堆栈顶端的第一个数值。如果是，将 1 推送到堆栈顶端；否则，推送 0。
- **气体费用**: 3 gas
- **示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GTExample {
    function greaterThan(uint256 a, uint256 b) public pure returns (bool) {
        bool result;
        assembly {
            result := gt(a, b)
        }
        return result;
    }
}
```

## 3.有符号小于指令 SLT

- **操作码**: 0x12
- **功能**: 进行有符号整数比较，检查堆栈顶端的第二个数值是否小于堆栈顶端的第一个数值。如果是，将 1 推送到堆栈顶端；否则，推送 0。
- **气体费用**: 3 gas
- **示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SLTExample {
    function signedLessThan(int256 a, int256 b) public pure returns (bool) {
        bool result;
        assembly {
            result := slt(a, b)
        }
        return result;
    }
}
```

## 6.有符号大于指令 SGT

- **操作码**: 0x13
- **功能**: 进行有符号整数比较，检查堆栈顶端的第二个数值是否大于堆栈顶端的第一个数值。如果是，将 1 推送到堆栈顶端；否则，推送 0。
- **气体费用**: 3 gas
- **示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SGTExample {
    function signedGreaterThan(int256 a, int256 b) public pure returns (bool) {
        bool result;
        assembly {
            result := sgt(a, b)
        }
        return result;
    }
}
```

## 7.等于指令 EQ

- **操作码**: 0x14
- **功能**: 比较堆栈顶端的两个数值是否相等。如果相等，将 1 推送到堆栈顶端；否则，推送 0。
- **气体费用**: 3 gas
- **示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EQExample {
    function equal(uint256 a, uint256 b) public pure returns (bool) {
        bool result;
        assembly {
            result := eq(a, b)
        }
        return result;
    }
}
```

## 8.是否为零指令 ISZERO

- **操作码**: 0x15
- **功能**: 检查堆栈顶端的数值是否为零。如果是，将 1 推送到堆栈顶端；否则，推送 0。
- **气体费用**: 3 gas
- **示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ISZEROExample {
    function isZero(uint256 a) public pure returns (bool) {
        bool result;
        assembly {
            result := iszero(a)
        }
        return result;
    }
}
```