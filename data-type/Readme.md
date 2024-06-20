# 一文读懂 Solidity 数据类型

Solidity 里面的变量可以分为以下三个类别：
- 值类型：包括布尔型，整数型等，这类变量赋值时候直接传递数值。
- 引用类型：包括数组和结构体，这类变量占空间大，赋值时候直接传递地址（类似指针）。
- 映射类型： Solidity中存储键值对的数据结构，可以理解为哈希表

## 1.值类型
值类型是指那些直接存储在合约状态变量或者函数栈中的数据类型。与引用类型不同，值类型的赋值和传递是通过复制整个数据对象的值进行的，而不是通过引用或指针。

### 1.1.Bool 类型

#### 1.1.1. Bool 类型介绍
bool 类型用于表示布尔值，即 true 或 false。布尔类型的变量通常用于控制流程、状态检查和条件判断。下面是有关 Solidity 中 bool 类型的一些基本用法和示例：

- 声明布尔变量
``` 
bool public isActive;
```
- 初始化布尔变量
```
bool public isActive = true;
```
布尔运算 Solidity 支持基本的布尔运算，如逻辑与（&&）、逻辑或（||）和逻辑非（!），和其他语言一样，&& 和 || 运算符遵循短路规则
```
bool a = true;
bool b = false;
bool resultAnd = a && b; // false
bool resultOr = a || b;  // true
bool resultNot = !a;     // false
```
#### 1.1.2.常见操作
- 与（AND）操作：&&
```
bool result = isActive && isCompleted; // 如果两个变量都是 true，result 才为 true
```
- 或（OR）操作：||
```
bool result = isActive || isCompleted; // 如果任意一个变量是 true，result 就为 true
```
- 非（NOT）操作：!
```
bool result = !isActive; // 如果 isActive 是 true，result 为 false
```
这些布尔操作和示例合约展示了 bool 类型在 Solidity 中的基本用法。通过这些操作，可以实现复杂的逻辑控制和状态管理。

### 1.2.整型
在 Solidity 中，整型（integer）类型用于表示整数。Solidity 支持有符号整型和无符号整型。

#### 1.2.1.无符号整型（uint）
无符号整型表示非负整数，关键字是 uint。可以指定位宽（从 uint8 到 uint256，每增加 8 位），默认是 uint256。
```
uint public myUint;      // 默认 uint256
uint8 public myUint8;
uint16 public myUint16;
uint256 public myUint256;
```

#### 1.2.2.有符号整型（int）

有符号整型表示正负整数，关键字是 int。可以指定位宽（从 int8 到 int256，每增加 8 位），默认是 int256。

```
int public myInt;        // 默认 int256
int8 public myInt8;
int16 public myInt16;
int256 public myInt256;
```

#### 1.2.3.溢出和下溢
在早期的 Solidity 版本中，整型溢出和下溢是一个常见的问题。为了处理这个问题，可以使用 SafeMath 库。然而，从 Solidity 0.8.0 开始，整型运算默认包含了溢出和下溢检查，不再需要使用 SafeMath。

```
pragma solidity ^0.8.0;

contract OverflowExample {
    uint8 public maxUint8 = 255;

    function increment() public {
        maxUint8 += 1; // 这将导致运行时错误，因为 uint8 的最大值是 255
    }
}
```

#### 1.2.4.常用的整型运算符包括：
- 比较运算符（返回布尔值）： <=， <，==， !=， >=， >
- 算数运算符： +， -， *， /， %（取余），**（幂）

#### 1.2.5.示范代码

```
pragma solidity ^0.8.0;

contract IntegerExample {
    // 无符号整型变量
    uint public myUint = 1;
    uint8 public myUint8 = 255; // 最大值 255
    uint256 public myUint256 = 2**256 - 1; // 最大值 2^256-1

    // 有符号整型变量
    int public myInt = -1;
    int8 public myInt8 = 127; // 最大值 127，最小值 -128
    int256 public myInt256 = 2**255 - 1; // 最大值 2^255-1，最小值 -(2^255)

    // 设置无符号整型变量
    function setUint(uint _value) public {
        myUint = _value;
    }

    // 设置有符号整型变量
    function setInt(int _value) public {
        myInt = _value;
    }

    // 加法操作
    function addUint(uint _value) public {
        myUint += _value;
    }

    // 减法操作
    function subtractUint(uint _value) public {
        myUint -= _value;
    }

    // 乘法操作
    function multiplyUint(uint _value) public {
        myUint *= _value;
    }

    // 除法操作
    function divideUint(uint _value) public {
        require(_value != 0, "Cannot divide by zero");
        myUint /= _value;
    }

    // 加法操作
    function addInt(int _value) public {
        myInt += _value;
    }

    // 减法操作
    function subtractInt(int _value) public {
        myInt -= _value;
    }

    // 乘法操作
    function multiplyInt(int _value) public {
        myInt *= _value;
    }

    // 除法操作
    function divideInt(int _value) public {
        require(_value != 0, "Cannot divide by zero");
        myInt /= _value;
    }
}
```

### 1.3. 地址类型
在 Solidity 中，地址类型 (address) 是一种特殊的数据类型，用于存储 Ethereum 地址。一个 Ethereum 地址是一个 20 字节（160 位）的值，通常用于表示账户（包括外部账户和合约账户）。地址类型有一些特定的功能和方法，允许开发者与区块链上的账户进行交互。
#### 1.3.1.基本用法
- 声明地址变量
```
address public exampleAddress;
```
- 初始化地址变量
```
address public exampleAddress = 0x1234567890123456789012345678901234567890;
```
#### 1.3.2.地址类型的特定方法
地址类型有一些内置的方法和属性，可以帮助我们与地址交互。
- 余额查询
```
uint256 balance = exampleAddress.balance;
```
- 发送 Ether
```
payable(exampleAddress).transfer(1 ether);
```
- 调用外部合约
```
(bool success, bytes memory data) = exampleAddress.call{value: 1 ether}("");
```
- address 与 address payable
在 Solidity 中，address 类型的变量不能接收或发送 Ether。如果需要进行这些操作，需要使用 address payable 类型。
```
address payable public myPayableAddress;
```
#### 1.3.3.发送 Ether 的其他方法
除了 transfer 方法外，还有其他两种方法可以用来发送 Ether：send 和 call。
- send 方法: send 方法返回一个布尔值表示是否成功，不会抛出异常。
```
bool success = recipient.send(1 ether);
require(success, "Transfer failed");
```
- call 方法: call 方法是最通用的，它返回一个布尔值和一个字节数组，表示调用是否成功。
```
(bool success, ) = recipient.call{value: 1 ether}("");
require(success, "Transfer failed");
```

### 1.4.定长字节数组
定长字节数组是一种特定长度的字节序列，它们的长度在声明时就被固定。Solidity 提供了几种不同长度的定长字节数组类型，例如 bytes1 到 bytes32。

#### 1.4.1 定长字节数组的声明和初始化
定长字节数组的声明和初始化方式与普通变量类似，但需要指定固定的长度。以下是一些示例：
```
bytes1 public byte1Array;   // 单个字节
bytes2 public byte2Array;   // 两个字节
bytes3 public byte3Array;   // 三个字节
bytes32 public byte32Array; // 32 个字节
````
这些类型都是用来存储固定长度的字节序列的。它们在声明时会占据固定的存储空间，而不像动态大小的字节数组那样可以动态调整大小。

#### 1.4.2. 定长字节数组的操作
- 访问和赋值: 定长字节数组的元素可以像普通数组一样通过索引进行访问和赋值。

```
bytes2 public byte2Array;

function setByte2Array() public {
    byte2Array[0] = 0xAA;
    byte2Array[1] = 0xBB;
}

function getByteAtIndex(uint index) public view returns (byte) {
    require(index < byte2Array.length, "Index out of bounds");
    return byte2Array[index];
}
```
- 长度属性: 定长字节数组没有 .length 属性来获取数组的长度，因为它们的长度在声明时已经固定。
- 比较: 可以使用哈希函数 keccak256 来比较两个定长字节数组。
```
bytes2 public byte2Array1 = hex"1122";
bytes2 public byte2Array2 = hex"3344";

function compareArrays() public view returns (bool) {
    return keccak256(byte2Array1) == keccak256(byte2Array2);
}
```
- 初始化: 定长字节数组可以通过赋值或者构造函数初始化。
```
bytes2 public byte2Array = hex"1122";
```
#### 1.4.3.注意事项
- 定长字节数组的长度在声明时确定，并且不能更改。
- 当操作定长字节数组时，需要确保索引不超出数组的有效范围，以避免访问越界错误。
- 定长字节数组不支持动态大小调整，因此在使用时需要考虑到存储空间和 gas 成本。

### 1.5.枚举
枚举（enum）是一种用户定义的数据类型，用于定义一组命名的常量。枚举类型允许开发者在代码中以易读的方式引用这些常量，而不必直接使用数值或字符串。

#### 1.5.1.定义枚举
枚举通过 enum 关键字定义。下面是一个简单的枚举定义示例：
```
pragma solidity ^0.8.0;

contract EnumExample {
    // 定义枚举类型
    enum State { Pending, Active, Inactive, Closed }

    // 定义枚举变量
    State public state;

    // 设置枚举状态
    function setState(State _state) public {
        state = _state;
    }

    // 获取当前枚举状态
    function getState() public view returns (State) {
        return state;
    }
}
```
在上面的示例中：
- State 是一个枚举类型，它包含四个枚举成员：Pending、Active、Inactive 和 Closed。
- state 是一个公共的状态变量，它的类型是 State，用于存储枚举类型的值。
- setState 函数用来设置 state 的值，接受一个 State 类型的参数。
- getState 函数返回当前存储在 state 中的枚举值。

#### 1.5.2.枚举值和默认值
枚举的每个成员都会自动分配一个整数索引，从 0 开始递增。在上面的例子中，Pending 的值为 0，Active 的值为 1，以此类推。如果没有显式地指定枚举成员的值，它们将按顺序从 0 开始递增。

#### 1.5.3. 使用枚举的优势
枚举的主要优势在于增强代码的可读性和可维护性。例如，在状态机中，使用枚举可以更清晰地表示不同的状态。另外，枚举类型在合约中的内部使用也有助于避免使用硬编码的数值或字符串。

#### 1.5.4.注意事项
- 枚举类型在 Solidity 中是值类型，它们在存储和传递时是按值复制的。
- 枚举成员名称必须是唯一的。
- 枚举成员可以显式地指定数值，例如 enum State { A = 10, B = 20 }。
- 枚举成员的数值可以是整数或者字符串，但字符串类型只能在 Solidity 0.8.0 及以上版本使用。
使用枚举类型可以使 Solidity 合约中的代码更加清晰和易于理解，特别是在涉及状态管理或者有限集合的情况下。

## 2.引用类型
引用类型是一种特殊的数据类型，用于存储复杂的数据结构或者允许通过引用传递的数据类型。与值类型不同，引用类型的赋值和传递是通过引用或者指针进行的，这意味着它们在内存中是通过引用地址来操作的。
### 2.1. 结构体
结构体是一种用户定义的复合数据类型，用于存储多个不同类型的数据。结构体在 Solidity 中被视为引用类型，因为它们的赋值和传递是通过引用进行的。

#### 2.1.1.定义结构体
Solidity 中的结构体通过 struct 关键字来定义，如下所示：

```
pragma solidity ^0.8.0;

contract StructExample {
    // 定义结构体
    struct Person {
        string name;
        uint age;
        address walletAddress;
    }

    // 声明一个结构体类型的变量
    Person public myPerson;

    // 设置结构体数据
    function setPerson(string memory _name, uint _age, address _walletAddress) public {
        myPerson.name = _name;
        myPerson.age = _age;
        myPerson.walletAddress = _walletAddress;
    }

    // 获取结构体数据
    function getPerson() public view returns (string memory, uint, address) {
        return (myPerson.name, myPerson.age, myPerson.walletAddress);
    }
}
```

在上面的示例中：
- Person 是一个结构体类型，它包含三个成员变量：name（字符串类型）、age（无符号整数类型 uint）、walletAddress（地址类型 address）。
- myPerson 是一个公共的状态变量，用来存储一个 Person 结构体的实例。
- setPerson 函数用来设置 myPerson 结构体的各个成员变量的值。
- getPerson 函数返回当前存储在 myPerson 中的结构体数据。

#### 2.1.2. 结构体的使用
结构体可以帮助开发者更有效地组织和管理复杂的数据。它们可以作为函数的参数或返回值，也可以作为其他结构体或映射的成员变量。下面是一些结构体的使用示例：

```
pragma solidity ^0.8.0;

contract StructUsageExample {
    struct Employee {
        string name;
        uint age;
        address walletAddress;
    }

    mapping(address => Employee) public employees;

    // 添加新员工
    function addEmployee(address _employeeAddress, string memory _name, uint _age, address _walletAddress) public {
        employees[_employeeAddress] = Employee(_name, _age, _walletAddress);
    }

    // 获取员工信息
    function getEmployee(address _employeeAddress) public view returns (string memory, uint, address) {
        Employee memory emp = employees[_employeeAddress];
        return (emp.name, emp.age, emp.walletAddress);
    }
}
```

在上面的示例中：
- Employee 结构体定义了一个员工的基本信息。
- employees 是一个映射（mapping），将 address 类型的键映射到 Employee 结构体的值，用于存储不同员工的信息。
- addEmployee 函数用于向 employees 映射中添加新的员工信息。
- getEmployee 函数用于根据员工的地址获取其信息，并返回相关数据。

#### 2.1.3.注意事项
- 成员变量访问：结构体的成员变量可以通过点号 (.) 访问，例如 myPerson.name。
- 内存与存储：在函数内部使用结构体时，需要注意是否需要在存储区域（storage）或者内存区域（memory）中处理。
- 嵌套结构体：Solidity 支持结构体的嵌套定义，允许在一个结构体中包含另一个结构体作为成员变量。
- Gas 成本：对于复杂的结构体或者包含大量数据的结构体，需要注意 gas 成本和执行效率问题。
结构体是 Solidity 中用于组织和管理数据的重要工具，特别适用于复杂数据结构的描述和操作。在设计合约时，合理使用结构体可以使代码更加清晰、模块化和易于维护。

### 2.2.数组

数组在 Solidity 中也被视为引用类型，特别是动态大小的数组。动态大小的数组允许在运行时动态增加或减少其长度，这意味着它们的操作是基于引用的。

#### 2.2.1.定长数组 (type[N])
定长数组在声明时就需要指定数组的长度 N，且长度不能更改。定长数组通常用于固定大小的数据集合，如固定数量的数据元素存储。

```
pragma solidity ^0.8.0;

contract FixedArrayExample {
    uint[5] public fixedArray;

    // 设置数组元素
    function setFixedArray(uint index, uint value) public {
        require(index < 5, "Index out of bounds");
        fixedArray[index] = value;
    }

    // 获取数组元素
    function getFixedArray(uint index) public view returns (uint) {
        require(index < 5, "Index out of bounds");
        return fixedArray[index];
    }
}
```

在上面的示例中，fixedArray 是一个包含 5 个 uint 元素的定长数组。通过 setFixedArray 函数可以设置数组的元素值，通过 getFixedArray 函数可以获取指定索引处的元素值。

#### 2.2.2.动态数组 (type[])
动态数组是在 Solidity 中比较常见和灵活的数组类型，它的长度可以在运行时动态增加或减少。

```
pragma solidity ^0.8.0;

contract DynamicArrayExample {
    uint[] public dynamicArray;

    // 添加元素到数组
    function addElement(uint value) public {
        dynamicArray.push(value);
    }

    // 获取数组长度
    function getLength() public view returns (uint) {
        return dynamicArray.length;
    }

    // 获取数组指定索引处的值
    function getElement(uint index) public view returns (uint) {
        require(index < dynamicArray.length, "Index out of bounds");
        return dynamicArray[index];
    }
}
```
在上面的示例中，dynamicArray 是一个动态大小的 uint 数组。通过 addElement 函数可以向数组末尾添加新的元素，通过 getLength 函数可以获取当前数组的长度，通过 getElement 函数可以获取指定索引处的元素值。

#### 2.2.3.特点和使用注意事项
- Gas 成本：动态数组在增加元素时会消耗 gas，因此对于大型数组或频繁修改的数组操作，需要注意 gas 成本问题。
- 内存管理：动态数组在 Solidity 中会自动管理内存，无需手动释放或调整。
- 返回值：在 Solidity 中，函数不能返回完整的动态数组，如果需要返回数组，则通常需要返回数组的长度和元素的部分内容，或者使用外部函数接口。
- 多维数组：Solidity 支持多维数组，即数组中包含数组。

```
pragma solidity ^0.8.0;

contract MultiDimensionalArrayExample {
    uint[][] public multiArray;

    // 添加元素到二维数组
    function addElement(uint[] memory values) public {
        multiArray.push(values);
    }

    // 获取二维数组的长度
    function getLength() public view returns (uint) {
        return multiArray.length;
    }

    // 获取二维数组指定位置的元素
    function getElement(uint row, uint col) public view returns (uint) {
        require(row < multiArray.length, "Row index out of bounds");
        require(col < multiArray[row].length, "Column index out of bounds");
        return multiArray[row][col];
    }
}
```

在上面的示例中，multiArray 是一个二维动态数组，可以通过 addElement 添加一维数组到二维数组中，并通过 getLength 和 getElement 函数获取二维数组的长度和指定位置的元素值。
数组是 Solidity 中重要的数据结构之一，用于存储和操作大量相同类型的数据。合理使用数组可以有效管理和操作数据集合，提高合约的灵活性和效率。

### 2.3.映射
映射是 Solidity 中的一种特殊数据结构，用于存储键值对。映射也被视为引用类型，因为它们在内存中使用引用地址来操作
#### 2.3.1.定义映射

Solidity 中的映射通过 mapping 关键字定义，如下所示：

```
pragma solidity ^0.8.0;

contract MappingExample {
    // 定义映射，将地址映射到整数
    mapping(address => uint) public balances;

    // 设置地址对应的余额
    function setBalance(address _address, uint _balance) public {
        balances[_address] = _balance;
    }

    // 获取地址对应的余额
    function getBalance(address _address) public view returns (uint) {
        return balances[_address];
    }
}
```
在上面的示例中：
- balances 是一个映射，将 address 类型的键映射到 uint 类型的值，用于存储地址对应的余额信息。
- setBalance 函数用于设置指定地址 _address 的余额为 _balance。
- getBalance 函数用于获取指定地址 _address 的余额。

#### 2.3.2.映射的特性
- 键类型：映射的键可以是任何值类型，包括基本类型（如 uint、address）以及更复杂的类型（如 struct）。
- 值类型：映射的值可以是任何 Solidity 支持的数据类型，包括基本类型、复合类型（如 struct）和数组类型。
- 默认值：如果映射中不存在某个键对应的值，则返回该值类型的默认值。例如，uint 类型的默认值是 0，address 类型的默认值是 address(0)。
- Gas 成本：读取映射中的值（查找操作）是 gas 消耗较低的操作，而写入映射中的值（更新操作）可能会消耗更多的 gas，特别是在扩展映射时可能需要大量的 gas。

#### 2.3.3.映射的应用场景
映射在 Solidity 合约中有广泛的应用，特别是用于管理状态数据、存储关联数据和实现查找表。以下是一些常见的应用场景：
- 存储账户余额：如上面示例所示，映射可以用来存储多个账户的余额信息。
- ERC20 Token 实现：映射通常用于存储 ERC20 Token 的余额和授权信息。
- 存储关联数据：映射可以用于存储任何需要通过某种键快速查找和访问的关联数据。
- 索引和查找：映射可以作为索引来优化查找和检索操作，例如根据地址查找合约用户的信息。
2.3.4.注意事项
- 映射与数组：映射和数组都是 Solidity 中常用的数据结构，但它们的适用场景不同。映射适合于需要快速查找和更新的情况，而数组适合于顺序访问和处理的情况。
- 内存管理：映射中的键和值通常存储在存储区域（storage），这意味着它们在区块链上永久保存，并且可以在不同的合约函数之间共享和访问。
- 映射的限制：Solidity 中的映射不支持遍历操作，即不能直接遍历映射中的所有键或值。如果需要遍历操作，通常需要结合其他数据结构或模式来实现。
映射是 Solidity 中重要且强大的数据结构之一，合理使用映射可以有效提高合约的效率和可维护性。在设计合约时，根据具体需求选择合适的数据结构非常重要。

### 3.变量与常量

在 Solidity 中，常量（Constants）和变量（Variables）是两种不同的数据存储方式，它们在合约中的使用和特性有所不同。下面将分别介绍 Solidity 中的常量和变量，并举例说明它们的使用方法和注意事项。

#### 3.1.常量 (Constants)
常量在 Solidity 中是指一旦声明后其值无法更改的数据。常量的声明方式是使用 constant 或 immutable 关键字。主要特点包括：
- 初始化后不可更改：常量在声明时需要立即赋值，并且其值在合约的生命周期内保持不变。
- 编译时确定：常量的值在编译时确定，并且在部署时被写入合约的字节码中。
- 不占用存储空间：常量不占用合约的存储空间，而是在代码中直接使用其值。
下面是常量的示例：

```
pragma solidity ^0.8.0;

contract ConstantsExample {
    // 声明常量
    uint constant public MAX_NUMBER = 100;
    address constant public OWNER = 0x1234567890123456789012345678901234567890;
    string constant public VERSION = "1.0.0";

    // 常量不可更改，以下语句会引发编译错误
    // function updateConstants() public {
    //     MAX_NUMBER = 200;
    // }
}
```
在上面的示例中：
- MAX_NUMBER、OWNER 和 VERSION 都是常量，它们分别代表最大数值、合约拥有者的地址和版本号，它们的值在声明时确定，并且无法在合约内部更改。

### 3.2.变量 (Variables)

变量是 Solidity 中用于存储和管理数据的可变容器。主要特点包括：
- 可变性：变量在声明后可以根据需要进行修改和更新。
- 存储空间：变量会占用合约的存储空间，可以存储状态和临时数据。
- 作用域：变量可以是合约级别的状态变量，也可以是函数内的局部变量。
下面是变量的示例：
```
pragma solidity ^0.8.0;

contract VariablesExample {
    // 状态变量
    uint public count;

    // 函数示例，包含局部变量
    function updateCount(uint _newCount) public {
        uint localVar = 42;  // 局部变量
        count = _newCount;
    }
}
```
在上面的示例中：
- count 是一个公共的状态变量，用于存储合约中的一个整数值。
- updateCount 函数包含一个局部变量 localVar，用于存储临时数据，_newCount 参数用于更新 count 的值。
### 3.3.使用建议
- 常量 vs 变量：根据需求选择合适的常量或变量。常量适用于在合约中需要固定且不可变的值，而变量适用于需要存储和修改的动态数据。
- Gas 成本：读取常量的 gas 成本较低，因为它们的值在编译时已经确定；而更新变量或者读取状态变量可能会涉及更高的 gas 成本，尤其是在合约存储空间的使用方面。
- 安全性：在编写合约时，合理使用常量和变量可以提高合约的安全性和可读性，避免不必要的状态变化和复杂的逻辑。
通过合理使用常量和变量，Solidity 开发者可以有效管理和操作合约中的数据，确保合约的功能和逻辑符合预期，并且在 gas 使用和执行效率方面进行优化。
