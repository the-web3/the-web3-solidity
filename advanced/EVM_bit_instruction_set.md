# EVM 位指令集

在以太坊虚拟机（EVM）中，位级指令用于对堆栈顶端的数值进行按位操作。这些指令包括按位与（AND）、按位或（OR）、按位异或（XOR）、按位非（NOT）、字节提取（BYTE）、左移（SHL）、逻辑右移（SHR）、算术右移（SAR）。以下是详细介绍：

# 1.按位与指令 AND

- **操作码**: 0x16
- **功能**: 对堆栈顶端的两个数值进行按位与操作，并将结果推送回堆栈顶端。
- **气体费用**: 3 gas
- **示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ANDExample {
    function bitwiseAnd(uint256 a, uint256 b) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := and(a, b)
        }
        return result;
    }
}
```

## 2.按位或指令 OR

- **操作码**: 0x17
- **功能**: 对堆栈顶端的两个数值进行按位或操作，并将结果推送回堆栈顶端。
- **气体费用**: 3 gas
- **示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ORExample {
    function bitwiseOr(uint256 a, uint256 b) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := or(a, b)
        }
        return result;
    }
}
```

## 3.按位异或指令 XOR

- **操作码**: 0x18
- **功能**: 对堆栈顶端的两个数值进行按位异或操作，并将结果推送回堆栈顶端。
- **气体费用**: 3 gas
- **示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract XORExample {
    function bitwiseXor(uint256 a, uint256 b) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := xor(a, b)
        }
        return result;
    }
}
```

# 4.按位非指令 NOT

- **操作码**: 0x19
- **功能**: 对堆栈顶端的数值进行按位非操作，并将结果推送回堆栈顶端。
- **气体费用**: 3 gas
- **示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NOTExample {
    function bitwiseNot(uint256 a) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := not(a)
        }
        return result;
    }
}
```

# 5.字节提取指令 BYTE

- **操作码**: 0x1A
- **功能**: 提取堆栈顶端第二个数值的指定字节。
- **气体费用**: 3 gas
- **示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BYTEExample {
    function extractByte(uint256 position, uint256 value) public pure returns (uint8) {
        uint8 result;
        assembly {
            result := byte(position, value)
        }
        return result;
    }
}
```

# 6.左移指令 SHL

- **操作码**: 0x1B
- **功能**: 对堆栈顶端的数值进行左移操作，并将结果推送回堆栈顶端。
- **气体费用**: 3 gas
- **示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SHLExample {
    function shiftLeft(uint256 value, uint256 bits) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := shl(bits, value)
        }
        return result;
    }
}
```

# 7.逻辑右移指令 SHR

- **操作码**: 0x1C
- **功能**: 对堆栈顶端的数值进行逻辑右移操作，并将结果推送回堆栈顶端。
- **气体费用**: 3 gas
- **示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SHRExample {
    function shiftRight(uint256 value, uint256 bits) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := shr(bits, value)
        }
        return result;
    }
}
```

# 9.算术右移指令 SAR

- **操作码**: 0x1D
- **功能**: 对堆栈顶端的数值进行算术右移操作，并将结果推送回堆栈顶端。
- **气体费用**: 3 gas
- **示例**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SARExample {
    function arithmeticShiftRight(int256 value, uint256 bits) public pure returns (int256) {
        int256 result;
        assembly {
            result := sar(bits, value)
        }
        return result;
    }
}
```