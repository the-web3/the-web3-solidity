# Solidity 函数与事件

# 一. 函数

函数是用来执行特定任务或操作的代码块。函数可以包含逻辑、访问状态变量，进行计算，并且可以接受参数和返回值。

## 1.定义函数

Solidity 中的函数定义如下：

```solidity
pragma solidity ^0.8.0;

contract FunctionExample {
    // 状态变量
    uint public data;

    // 函数定义
    function setData(uint _data) public {
        data = _data;
    }

    // 函数定义，带返回值
    function getData() public view returns (uint) {
        return data;
    }
}
```

在上面的示例中，我们定义了两个函数：

- setData(uint _data)：设置合约中的 data 状态变量为传入的 _data 值。这是一个修改状态的函数，使用 public 关键字使其可以被外部调用。
- getData() public view returns (uint)：返回合约中的 data 状态变量的值。这是一个只读函数，使用 view 关键字表明它不修改合约状态，并且声明了返回类型为 uint。

## 2.函数特性

Solidity 中的函数具有以下特性：

- **可见性修饰符**：函数可以使用 public、internal、external 和 private 来指定访问权限。默认为 public。
- **状态变量访问**：函数可以读取和修改合约中的状态变量。
- **参数和返回值**：函数可以接受参数和返回值。参数可以是任何 Solidity 支持的数据类型，包括基本类型、复合类型（如结构体）、数组和映射等。
- **函数修饰符**：通过使用 pure、view、payable 和 virtual 等修饰符来定义函数的特性和行为。例如，view 表示函数只读取数据但不修改状态，payable 表示函数可以接收以太币支付。
- **事件触发**：函数可以通过 emit 关键字触发事件，用于通知客户端合约中的重要状态变化。
- **函数重载**：Solidity 支持函数重载，允许定义具有相同名称但不同参数列表的多个函数。

可见性修饰符, 函数修饰符和 函数重载 重载是函数中比较重要的内容，我们下面在详细讲解，关于合约事件，我们有专门的专题课程讲解。

**2.1.可见性修饰符**

函数可以使用 public、internal、external 和 private 来指定访问权限。默认为 public。

- public 修饰符指定函数或状态变量可以被合约内部的其他合约和外部账户访问。对于函数而言，它们可以被合约内部和外部调用；对于状态变量而言，它们可以被合约内部和外部读取。
- internal 修饰符指定函数或状态变量只能被当前合约及其派生合约内部访问。外部账户和合约无法直接访问或调用带有 internal 修饰符的函数或状态变量。
- private 修饰符指定函数或状态变量只能被当前合约内部访问，即使是合约的派生合约也无法直接访问带有 private 修饰符的成员。
- external 修饰符指定函数只能被外部账户和合约调用，即只能从合约外部进行访问。external 函数不能在合约内部或者合约的其他函数中直接调用。

**2.2.注意事项**

- **默认可见性**：如果不显式指定可见性修饰符，则默认为 public。这意味着如果你只想让函数或状态变量在合约内部使用，应该显式使用 internal 或 private。
- **Gas 成本**：不同的可见性修饰符可能会影响函数调用的 gas 成本，特别是 external 函数的 gas 成本较高，因为它们需要进行消息调用。
- **安全性**：合理使用可见性修饰符可以提高合约的安全性和可读性，避免不必要的访问和操作。

2.3.**函数修饰符**

pure、view、payable 和 virtual 是函数修饰符，用于定义函数的行为和特性。它们在函数的调用方式、状态变更、gas 消耗等方面有所不同。下面详细介绍这些修饰符的区别和用法：

**Pure**

- 作用：pure 修饰符用于声明函数不读取合约状态，也不修改合约状态，即完全不访问状态变量。
- 特点： 不允许访问 this 和 msg 对象。 可以在编译时被内联优化。 不能发送以太币（Ether）。
- 示例：

```solidity
pragma solidity ^0.8.0;

contract PureExample {
    // pure 函数示例
    function add(uint a, uint b) public pure returns (uint) {
        return a + b;
    }
}
```

**View**

- 作用：view 修饰符用于声明函数不修改合约状态，但可以读取合约的状态变量。
- 特点： 可以调用其他 view 或 pure 函数。 不允许修改状态变量。 不允许发送以太币（Ether）。
- 示例：

```solidity
pragma solidity ^0.8.0;

contract ViewExample {
    uint public data;

    // view 函数示例
    function getData() public view returns (uint) {
        return data;
    }
}
```

**Payable**

- 作用：payable 修饰符用于声明函数可以接收以太币（Ether）支付。
- 特点： 允许函数接收以太币。 可以调用其他 payable 函数。 可以读取合约状态变量（如果是 view 或 pure 函数）。 不能修改状态变量（如果是 view 函数）。
- 示例：

```solidity
pragma solidity ^0.8.0;

contract PayableExample {
    // payable 函数示例
    function receiveEther() public payable {
        // 接收以太币
    }
}
```

**Virtual**

- 作用：virtual 修饰符用于声明函数可以被派生合约重写（覆盖）。
- 特点： 在父合约中声明函数为 virtual，表示该函数可以在派生合约中被重写。 派生合约中可以使用 override 关键字重写 virtual 函数。 virtual 函数可以有默认实现，但也可以是纯虚函数（即没有实现，只是声明）。
- 示例：

```solidity
pragma solidity ^0.8.0;

contract Base {
    // virtual 函数示例
    function getValue() public virtual returns (uint) {
        return 10;
    }
}

contract Derived is Base {
    // override 覆盖基类函数
    function getValue() public virtual override returns (uint) {
        return 20;
    }
}
```

**总结**

- pure：不读取状态变量，不修改状态，不能发送以太币。
- view：不修改状态变量，可以读取状态变量，不能发送以太币。
- payable：可以接收以太币，可以读取状态变量（如果是 view 或 pure 函数），不能修改状态变量（如果是 view 函数）。
- virtual：声明函数可以被派生合约重写，派生合约中使用 override 关键字进行重写。

正确使用这些修饰符可以帮助开发者定义和实现合约中不同类型的函数，以及确保合约的功能和安全性。

**2.4. 函数重写和重载**

在 Solidity 中，函数重写（override）和函数重载（overload）是两个概念，它们在面向对象编程中有特定的含义和用法。

**2.4.1.函数重写（Override）**

函数重写指的是在派生合约（子合约）中重新定义父合约中已存在的虚函数（virtual function）。在 Solidity 中，通过在派生合约中使用 override 关键字来标识要重写的函数。

```solidity
pragma solidity ^0.8.0;

contract Base {
    function getValue() public virtual returns (uint) {
        return 10;
    }
}

contract Derived is Base {
    function getValue() public virtual override returns (uint) {
        return 20;
    }
}
```

在上面的示例中：

- Base 合约中定义了一个虚函数 getValue，返回固定的整数值 10。
- Derived 合约继承自 Base 合约，并重写了 getValue 函数，返回整数值 20。使用了 override 关键字标识。

函数重写允许派生合约在不改变原有合约结构的情况下，根据具体的需求重定义函数的行为。

**2.4.2.函数重载（Overload）**

函数重载指的是在同一个合约中定义多个具有相同函数名但不同参数列表的函数。Solidity 支持函数重载，根据参数的类型和数量来区分不同的函数定义。

```solidity
pragma solidity ^0.8.0;

contract OverloadExample {
    function foo(uint _value) public pure returns (uint) {
        return _value;
    }

    function foo(uint _value, uint _value2) public pure returns (uint) {
        return _value + _value2;
    }

    function foo(string memory _text) public pure returns (string memory) {
        return _text;
    }
}
```

在上面的示例中：

- OverloadExample 合约定义了三个名为 foo 的函数，它们分别接受不同类型和数量的参数，但函数名相同。

函数重载允许在同一个合约中根据参数的不同，提供不同的函数实现。Solidity 编译器会根据函数的参数列表生成唯一的函数签名，以便区分不同的函数定义。

**2.4.3.区别总结**

- **函数重写**（Override）：发生在派生合约中，重新定义父合约中已存在的虚函数，使用 override 关键字标识。
- **函数重载**（Overload）：发生在同一个合约中，定义具有相同函数名但不同参数列表的多个函数，根据参数的类型和数量来区分。

**2.4.4. 注意事项**

- Solidity 中的函数重写和重载可以帮助开发者根据具体的需求和逻辑，更灵活地设计和实现合约的功能。
- 在使用函数重载时，应当注意参数列表的唯一性，避免出现二义性，确保函数能够正确地被调用和使用。
- 函数重写通常用于实现继承中的多态特性，而函数重载则用于提供不同的功能选项或操作符号重载等场景。

## 3.函数选择器

Solidity 中的函数选择器（Function Selector）是用来唯一标识函数签名的哈希值，它通常与函数调用和 ABI 编码相关联。在 Solidity 中，每个函数都有一个对应的函数选择器，用来标识函数的名称和参数类型，以便在合约内部和外部进行函数调用时进行唯一识别。

**3.1.函数选择器的计算方法**

Solidity 中的函数选择器是通过将函数签名（函数名称及其参数类型的 ABI 编码）进行 keccak256 哈希计算得到的。具体步骤如下：

- **ABI 编码**：将函数的名称和参数类型进行 ABI 编码。ABI 编码是一种规范化的字节序列，用于描述函数调用或合约间通信的参数和返回值。
- **计算哈希**：对 ABI 编码的结果应用 keccak256 哈希算法。Solidity 使用的函数选择器是这个哈希值的前 4 个字节（32位）。

**3.2.示例**

考虑以下 Solidity 合约中的一个函数：

```solidity
pragma solidity ^0.8.0;

contract ExampleContract {
    uint256 public value;

    function setValue(uint256 _value) public {
        value = _value;
    }
}
```

- setValue 函数的函数选择器计算示例： **ABI 编码**：setValue(uint256) 的 ABI 编码为 0x60fe47b10000000000000000000000000000000000000000000000000000000000000042。 **计算哈希**：对 ABI 编码进行 keccak256 哈希计算得到 0x60fe47b1...。 **函数选择器**：取哈希值的前 4 个字节，即 0x60fe47b1。
- Solidity 中的函数选择器应用示例：

```solidity
pragma solidity ^0.8.0;

contract CallerContract {
    ExampleContract public exampleContract;

    constructor(address _exampleContract) {
        exampleContract = ExampleContract(_exampleContract);
    }

    function callSetValue(uint256 _value) public {
        exampleContract.setValue(_value);
    }

    function getSetValueSelector() public pure returns (bytes4) {
        return exampleContract.setValue.selector;
    }
}
```

- exampleContract.setValue.selector 返回 setValue 函数的选择器 bytes4 类型的值，即 0x60fe47b1。
- 在 callSetValue 函数中，使用了 setValue 函数的选择器来调用 exampleContract 合约中的 setValue 函数。

**3.3.作用和应用**

- **ABI 解析**：在 Solidity 合约内部和外部，函数选择器用于将函数签名解析为可执行的函数调用。
- **跨合约调用**：通过函数选择器，可以在合约之间准确调用指定函数，确保参数的正确传递和类型匹配。

通过理解 Solidity 中函数选择器的计算方法和应用，可以更有效地进行合约开发和交互操作，确保函数调用的正确性和安全性。

# 二.事件

在 Solidity 中，事件（Events）是一种合约特有的通信机制，用于向外部应用程序通知关键信息。事件允许合约与区块链上的外部系统进行交互，典型的应用包括记录状态变化、提供数据查询以及与前端应用程序进行实时通信等。下面详细说明 Solidity 中事件的定义、使用和特性。

## 1.定义事件

在 Solidity 中，事件是通过 event 关键字定义的。事件定义通常放在合约的顶层，其语法如下：

```
event EventName(address indexed _addressParam, uint _uintParam, string _stringParam);
```

- EventName 是事件的名称。
- address indexed _addressParam、uint _uintParam、string _stringParam 是事件的参数列表。在事件中可以定义多个参数，可以是任何 Solidity 支持的数据类型，包括基本类型、结构体、数组和映射等。
- indexed 关键字用于指定该参数为索引参数，允许外部应用程序通过该参数进行快速检索。

## 2.触发事件

在 Solidity 合约中，使用 emit 关键字触发事件。通常在合约内部的函数中触发事件，以记录合约状态的重要变化或者向外部应用程序发送通知。

```solidity
pragma solidity ^0.8.0;

contract EventExample {
    event NewUserRegistered(address indexed user, uint timestamp);

    function registerUser() public {
        // 假设有一些逻辑用来注册新用户
        address newUser = msg.sender;
        uint timestamp = block.timestamp;

        // 触发事件
        emit NewUserRegistered(newUser, timestamp);
    }
}
```

在上面的示例中：

- NewUserRegistered 是一个事件，它记录了新用户注册的信息，包括用户地址和注册时间戳。
- registerUser 函数是一个示例函数，用来模拟注册新用户的过程。当用户成功注册时，通过 emit 关键字触发 NewUserRegistered 事件，并传递相应的参数。

## 3.注意事项

- **Gas 成本**：触发事件会消耗 gas，特别是如果事件有多个索引参数或者频繁触发。应当注意控制事件触发的频率和消耗，以避免不必要的 gas 费用。
- **事件日志**：事件触发后，相关的数据将会被记录在区块链上的事件日志中。外部应用程序可以通过扫描事件日志来获取历史记录或者进行数据分析。
- **隐私性**：事件的参数可以是公开的（例如用户地址），但也可以通过合适的权限控制保护隐私。

使用事件是 Solidity 中常见的编程模式，能够有效地增强合约与外部世界的交互性和实时通信能力，是 DApp 开发中不可或缺的一部分。