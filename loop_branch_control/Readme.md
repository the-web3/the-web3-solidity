# Solidity 循环分支控制

在 Solidity 中，与大多数编程语言类似，循环和分支控制语句用于控制程序的流程和逻辑。这些结构使得 Solidity 合约能够根据条件执行特定的代码块或者重复执行代码。以下是 Solidity 中常用的循环和分支控制语句：

# 一. 分支控制

## **1.条件语句 (if, else if, else)**

条件语句用于根据表达式的结果选择性地执行代码块。

```solidity
pragma solidity ^0.8.0;

contract ControlStructures {
    uint public number;

    // 条件语句示例
    function setNumber(uint _num) public {
        if (_num > 10) {
            number = _num;
        } else if (_num == 5) {
            number = 5;
        } else {
            number = 0;
        }
    }
}
```

在上面的例子中：

- 如果 _num 大于 10，则将 number 设置为 _num。
- 如果 _num 等于 5，则将 number 设置为 5。
- 否则，将 number 设置为 0。

1.2.**断言语句 (assert, require)**

断言语句用于验证合约状态或函数参数的条件，并在条件不满足时抛出异常终止执行。

```solidity
pragma solidity ^0.8.0;

contract AssertionExample {
    uint public number;

    // 断言语句示例
    function setNumber(uint _num) public {
        require(_num > 0, "Number must be greater than zero");
        number = _num;
    }
}
```

require 语句用于检查条件 _num > 0 是否满足，如果不满足则抛出异常并终止执行。

# 二.循环结构

## 1.**for 循环**：

for 循环用于按照指定的次数重复执行代码块。

```solidity
pragma solidity ^0.8.0;

contract LoopExample {
    uint[] public numbers;

    // for 循环示例
    function addNumbers(uint _count) public {
        for (uint i = 0; i < _count; i++) {
            numbers.push(i);
        }
    }
}
```

在上面的例子中，addNumbers 函数通过 for 循环将从 0 到 _count-1 的整数依次添加到 numbers 数组中。

## 2.**while 循环**

while 循环用于在条件为真时重复执行代码块。

```solidity
pragma solidity ^0.8.0;

contract WhileLoopExample {
    uint public number;

    // while 循环示例
    function incrementUntilTen() public {
        while (number < 10) {
            number++;
        }
    }
}
```

在上面的例子中，incrementUntilTen 函数会持续增加 number 直到它大于或等于 10。

## 3.**do-while 循环**：

do-while 循环首先执行代码块，然后在条件为真时重复执行代码块。

```solidity
pragma solidity ^0.8.0;

contract DoWhileLoopExample {
    uint public number;

    // do-while 循环示例
    function incrementUntilTen() public {
        do {
            number++;
        } while (number < 10);
    }
}
```

在上面的例子中，incrementUntilTen 函数首先会增加 number，然后检查条件，如果条件满足则继续执行，直到 number 大于或等于 10。

## 4.注意事项

- **Gas 成本**：在 Solidity 合约中，循环和分支控制语句的执行会消耗 gas。特别是在循环中使用动态数据结构时要注意 gas 成本，避免不必要的 gas 消耗。
- **避免复杂逻辑**：尽量避免在合约中使用复杂的逻辑或者深层嵌套的控制结构，以确保合约的可读性和维护性。
- **安全性**：合约中的条件和断言语句对于确保合约的状态和操作是安全的非常重要，确保适当地使用断言和条件检查来验证输入和状态。

合理使用循环和分支控制结构可以帮助开发者实现复杂的逻辑和业务需求，同时也需要注意避免陷入不必要的复杂性和高 gas 消耗。