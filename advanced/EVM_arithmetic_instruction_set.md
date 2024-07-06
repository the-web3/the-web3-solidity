# EVM 算术指令集

EVM（以太坊虚拟机）的算术指令集用于在堆栈上执行基本的算术操作; EVM 算术指令包含，ADD，MUL, SUB, DIV, SDIV, MOD, SMOD, ADDMOD, MULMOD, EXP, SIGNEXTEND。下面我将分别介绍 EVM 的各个算术指令集的功能作用。

# 1.ADD 指令详解

在以太坊虚拟机（EVM）中，ADD 指令用于对堆栈顶端的两个数值进行加法运算，并将结果推送到堆栈顶端。

## 1.1.操作码和气体费用

- **名称**: ADD
- **操作码**: 0x01
- **气体费用**: 3 gas

## 1.2.功能

ADD 指令将堆栈顶端的两个数值相加，并将结果推送到堆栈顶端。

## 1.3.操作步骤

- **从堆栈中弹出两个值**: 从堆栈中弹出两个数值。第一个弹出的数值称为 value1，第二个弹出的数值称为 value2。
- **将两个值相加**: 计算 value1 + value2。
- **将结果推送到堆栈顶端**: 将计算结果推送到堆栈顶端。

## 1.4.示例

假设当前堆栈状态如下：

```
堆栈顶端 -> 0x03
           0x02
```

执行 ADD 指令后，堆栈状态将变为：

```
堆栈顶端 -> 0x05
```

**1.4.1.详细操作步骤**

初始堆栈状态：

```
堆栈顶端 -> 0x03
           0x02
```

执行 ADD 指令：

- 弹出 0x03（value1）。
- 弹出 0x02（value2）。
- 计算 0x03 + 0x02 = 0x05。
- 将 0x05 推送到堆栈顶端。

最终堆栈状态：

```
堆栈顶端 -> 0x05
```

## 1.5.注意事项

- ADD 指令用于无符号整数的加法运算，结果也为无符号整数。
- 当两个数值相加导致溢出时，结果将被截断为 256 位。EVM 不会抛出溢出错误，而是自动处理溢出情况。

# 2.MUL 指令详解

在以太坊虚拟机（EVM）中，MUL 指令用于对堆栈顶端的两个数值进行乘法运算，并将结果推送到堆栈顶端。

## 2.1.操作码和气体费用

- **名称**: MUL
- **操作码**: 0x02
- **气体费用**: 5 gas

## 2.2.功能

MUL 指令将堆栈顶端的两个数值相乘，并将结果推送到堆栈顶端。

## 2.3.操作步骤

- **从堆栈中弹出两个值**: 从堆栈中弹出两个数值。第一个弹出的数值称为 value1，第二个弹出的数值称为 value2。
- **将两个值相乘**: 计算 value1 * value2。
- **将结果推送到堆栈顶端**: 将计算结果推送到堆栈顶端。

## 2.4.示例

假设当前堆栈状态如下：

```
堆栈顶端 -> 0x03
           0x02
```

执行 MUL 指令后，堆栈状态将变为：

```
堆栈顶端 -> 0x06
```

**2.4.1.详细操作步骤**

初始堆栈状态：

```
堆栈顶端 -> 0x03
           0x02
```

执行 MUL 指令：

- 弹出 0x03（value1）
- 弹出 0x02（value2）
- 计算 0x03 * 0x02 = 0x06
- 将 0x06 推送到堆栈顶端

最终堆栈状态：

```
堆栈顶端 -> 0x06
```

## 2.5.注意事项

- MUL 指令用于无符号整数的乘法运算，结果也为无符号整数。
- 当两个数值相乘导致溢出时，结果将被截断为 256 位。EVM 不会抛出溢出错误，而是自动处理溢出情况。
- MUL 指令执行时消耗的 gas 为 5 gas，因此在进行大规模计算时需要考虑 gas 消耗问题。

## 3.SUB 指令详解

在以太坊虚拟机（EVM）中，减法指令 SUB 用于执行堆栈顶端两个数值的减法操作，并将结果推送回堆栈顶端。

## 3.1.操作码和气体费用

- 操作码: 0x03
- 气体费用: 3 gas

## 3.2.功能

SUB 指令执行减法操作，从堆栈顶端的第二个数值中减去堆栈顶端的第一个数值，并将结果推送回堆栈顶端。

## 3.3.操作步骤

- **减法操作**: 从堆栈顶端的第二个数值中减去堆栈顶端的第一个数值。
- **推送结果**: 将减法操作的结果推送到堆栈顶端。

## 3.4.示例

假设当前堆栈状态如下：

```
堆栈顶端 -> 0x03
           0x02
```

执行 SUB 指令后的堆栈状态将变为：

```
堆栈顶端 -> 0x01
```

3.4.1.详细操作步骤

初始堆栈状态：

```
堆栈顶端 -> 0x03
           0x02
```

执行 SUB 指令：

- 从堆栈顶端的第二个数值 0x02 中减去堆栈顶端的第一个数值 0x03。
- 结果为 0x01。

最终堆栈状态：

```
堆栈顶端 -> 0x01
```

## 3.5. Solidity 代码样例

如果你想直接看到 EVM 字节码中 SUB 操作的代码示例，可以通过 Solidity 的 assembly 块来手动编写和生成相应的字节码。下面是一个简单的 Solidity 合约示例，展示如何使用 assembly 块手动执行减法操作并生成对应的 EVM 字节码

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SubtractionAssembly {
    function subtract(uint256 a, uint256 b) public pure returns (uint256) {
        uint256 result;
        
        assembly {
            // 将参数 a 和 b 压入堆栈
            push {a}
            push {b}
            
            // 执行 SUB 操作
            sub
            
            // 将结果保存到 result 变量中
            pop {result}
        }
        
        return result;
    }
}
```

- **subtract 函数**: 接受两个参数 a 和 b，分别是要执行减法操作的数值。
- **assembly 块**: 使用 Solidity 的 assembly 块手动编写 EVM 字节码。 push {a} 和 push {b}: 将参数 a 和 b 推入堆栈顶部。 sub: 执行减法操作。 pop {result}: 将减法操作的结果从堆栈弹出，并将其存储在 Solidity 变量 result 中。
- **返回值**: 将减法操作的结果作为函数的返回值返回。

## 3.6.注意事项

- SUB 指令执行的是有符号整数的减法操作。
- 在实际使用中，需要注意数值的溢出情况，确保合约逻辑的正确性和安全性。
- 每次执行 SUB 指令会消耗 3 gas，是一种低成本的堆栈操作。

# 4. DIV 指令详解

在以太坊虚拟机（EVM）的操作码中，DIV 指令用于执行两个无符号整数的除法操作。

## 4.1.DIV 指令概述

- **操作码**: 0x04
- **操作码范围**: 0x04 - 0x05
- **气体费用**: 5 gas

## 4.2. 功能

DIV 指令执行整数除法操作，从堆栈顶端的第二个数值中除以堆栈顶端的第一个数值，并将结果推送回堆栈顶端。该操作是有符号的整数除法。

## 4.3.操作步骤

- **除法操作**: 从堆栈顶端的第二个数值中除以堆栈顶端的第一个数值。
- **推送结果**: 将除法操作的结果推送回堆栈顶端。

## 4.4.示例

假设当前堆栈状态如下：

```
堆栈顶端 -> 0x06
           0x02
```

执行 DIV 指令后的堆栈状态将变为：

```
堆栈顶端 -> 0x03
```

这是因为 0x06 / 0x02 的结果为 0x03

## 4.5. Solidity 代码样例

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DivisionAssembly {
    function divide(uint256 a, uint256 b) public pure returns (uint256) {
        uint256 result;
        
        assembly {
            // 将参数 a 和 b 压入堆栈
            push {b}
            push {a}
            
            // 执行 DIV 操作
            div
            
            // 将结果保存到 result 变量中
            pop {result}
        }
        
        return result;
    }
}
```

**divide 函数**: 接受两个参数 a 和 b，分别是要执行除法操作的数值。

**assembly 块**: 使用 Solidity 的 assembly 块手动编写 EVM 字节码。

- push {b} 和 push {a}: 将参数 b 和 a 推入堆栈顶部。注意，Solidity 中的 assembly 块使用的是逆序排列参数。
- div: 执行整数除法操作。
- pop {result}: 将除法操作的结果从堆栈弹出，并将其存储在 Solidity 变量 result 中。

**返回值**: 将整数除法操作的结果作为函数的返回值返回。

## 4.6. 注意事项

- DIV 指令执行的是有符号整数的除法操作。
- 需要注意除数不能为零，否则会导致 EVM 抛出异常。
- 在 Solidity 中，整数除法运算同样使用 / 操作符，而不是直接调用 DIV 指令。
- 每次执行 DIV 指令会消耗 5 gas，是一种较为昂贵的堆栈操作。

# 5. MOD 指令详解

在以太坊虚拟机（EVM）中，MOD 指令用于执行取模操作（也称为求余操作）。这个指令将堆栈顶端的两个数值进行取模运算，并将结果推送回堆栈顶端。

## 5.1.指令概述

- **操作码**: 0x06
- **气体费用**: 5 gas

## 5.2.功能

MOD 指令从堆栈顶端的第二个数值中取堆栈顶端的第一个数值的模，并将结果推送回堆栈顶端。也就是说，它计算 a % b 的结果，其中 a 是堆栈顶端的第二个数值，b 是堆栈顶端的第一个数值。

## 5.3.操作步骤

- **取模操作**: 从堆栈顶端的第二个数值中取堆栈顶端的第一个数值的模。
- **推送结果**: 将取模操作的结果推送回堆栈顶端。

## 5.4.示例

假设当前堆栈状态如下：

```
堆栈顶端 -> 0x03
           0x0A
```

执行 MOD 指令后的堆栈状态将变为：

```
堆栈顶端 -> 0x01
```

这是因为 0x0A % 0x03 的结果为 0x01。

## 5.5.注意事项

- MOD 指令执行的是无符号整数的取模操作。
- 需要注意取模的第二个数值（即除数）不能为零，否则会导致 EVM 抛出异常。
- 在 Solidity 中，整数取模运算使用 % 操作符，而不是直接调用 MOD 指令。
- 每次执行 MOD 指令会消耗 5 gas，是一种较为昂贵的堆栈操作。

## 5.6.示例 Solidity 代码

在 Solidity 中，可以通过 assembly 块来使用 MOD 指令。以下是一个简单示例：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ModulusExample {
    function modulus(uint256 a, uint256 b) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := mod(a, b)
        }
        return result;
    }
}
```

- **modulus 函数**: 接受两个参数 a 和 b，分别是要执行取模操作的数值。
- **assembly 块**: 使用 Solidity 的 assembly 块手动编写 EVM 字节码。 mod(a, b): 执行取模操作，并将结果存储在 Solidity 变量 result 中。
- **返回值**: 将取模操作的结果作为函数的返回值返回。

# 6.EXP 指令详解

## 6.1.指令概述

- **操作码**: 0x0A
- **气体费用**: 基本费用 10 gas + 50 gas per byte of the exponent

## 6.2.功能

EXP 指令从堆栈顶端的第二个数值作为底数，堆栈顶端的第一个数值作为指数进行运算，并将结果推送回堆栈顶端。即它计算 base^exponent。

## 6.3.操作步骤

- **指数运算**: 计算 base^exponent，其中 base 是堆栈顶端的第二个数值，exponent 是堆栈顶端的第一个数值。
- **推送结果**: 将指数运算的结果推送回堆栈顶端。

## 6.4.示例

假设当前堆栈状态如下：

```
堆栈顶端 -> 0x03  // exponent
           0x02  // base
```

执行 EXP 指令后的堆栈状态将变为：

```
堆栈顶端 -> 0x08  // 2^3 = 8
```

## 6.5.注意事项

- EXP 指令的气体费用包含基本费用和每字节指数费用。指数的每个字节消耗 50 gas。
- 在指数值较大时，运算的气体费用会显著增加。
- 需要注意指数运算的结果可能会非常大，需要考虑结果是否会超出 256 位。

## 6.6. Solidity 代码

在 Solidity 中，可以通过 assembly 块来使用 EXP 指令。以下是一个简单示例：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ExponentiationExample {
    function exponentiate(uint256 base, uint256 exponent) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := exp(base, exponent)
        }
        return result;
    }
}
```

- **exponentiate 函数**: 接受两个参数 base 和 exponent，分别是要执行指数运算的底数和指数。
- **assembly 块**: 使用 Solidity 的 assembly 块手动编写 EVM 字节码。 exp(base, exponent): 执行指数运算，并将结果存储在 Solidity 变量 result 中。
- **返回值**: 将指数运算的结果作为函数的返回值返回。

# 7.SIGNEXTEND 指令详解

SIGNEXTEND 指令在以太坊虚拟机（EVM）中用于将一个数值扩展为带符号的数值。这个指令在处理不同大小的整数转换时特别有用。

## 7.1.指令概述

- **操作码**: 0x0B
- **气体费用**: 5 gas

## 7.2.功能

SIGNEXTEND 指令从堆栈中取出两个数值 k 和 x，然后对数值 x 进行带符号扩展。具体来说，它将 x 的第 k 字节的符号位扩展到整个数值的高位。

## 7.3.操作步骤

- **取出操作数**: 从堆栈中取出两个数值，堆栈顶端的第一个数值是 k，第二个数值是 x。
- **带符号扩展**: 对 x 进行带符号扩展，即将 x 的第 k 字节的符号位扩展到整个数值的高位。
- **推送结果**: 将扩展后的数值推送回堆栈顶端。

## 7.4.示例

假设当前堆栈状态如下：

```
堆栈顶端 -> 0x01  // k
           0x0000000000000000000000000000000000000000000000000000000000000080  // x
```

执行 SIGNEXTEND 指令后的堆栈状态将变为：

```
堆栈顶端 -> 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF  // -128 带符号扩展后的结果
```

这是因为 x 的第 k 字节（即第 1 字节）的符号位是 1，所以扩展后，所有高位都填充符号位 1。

## 7.5.注意事项

- k 的范围为 0 到 31，表示字节位置。
- 如果 k 超出范围，则 SIGNEXTEND 指令不会改变 x 的值。
- 带符号扩展用于将较小的有符号数转换为较大的有符号数，同时保持其值。

## 7.6. Solidity 代码

在 Solidity 中，可以通过 assembly 块来使用 SIGNEXTEND 指令。以下是一个简单示例：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SignExtendExample {
    function signExtend(uint256 k, uint256 x) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := signextend(k, x)
        }
        return result;
    }
}
```

- **signExtend 函数**: 接受两个参数 k 和 x，分别是扩展操作的字节位置和要扩展的数值。
- **assembly 块**: 使用 Solidity 的 assembly 块手动编写 EVM 字节码。 signextend(k, x): 执行带符号扩展操作，并将结果存储在 Solidity 变量 result 中。
- **返回值**: 将带符号扩展操作的结果作为函数的返回值返回。

通过理解 SIGNEXTEND 指令的功能和使用场景，开发者可以更好地处理不同大小的整数转换，确保智能合约的正确性和高效运行。

# 8.其他指令集

## 8.1.**SDIV**

- **Opcode**: 0x05
- **描述**: 两个有符号整数相除，返回商。
- **栈操作**: POP a, b -> PUSH (a / b)

## **8.2.SMOD**

**Opcode**: 0x07

**描述**: 两个有符号整数相除，返回余数。

**栈操作**: POP a, b -> PUSH (a % b)

## **8.3.ADDMOD**

- **Opcode**: 0x08
- **描述**: (a + b) % c
- **栈操作**: POP a, b, c -> PUSH ((a + b) % c)

## 8.4.**MULMOD**

- **Opcode**: 0x09
- **描述**: (a * b) % c
- **栈操作**: POP a, b, c -> PUSH ((a * b) % c)