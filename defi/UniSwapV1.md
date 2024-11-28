# 深入剖析 UniSwap V1 原理及源码

# 一. Uniswap 概述

## 1.Uniswap 之前的 Dex 形态

在 Uniswap 之前，去中心化交易所（DEX）的形态主要是基于订单簿的模型，这种模型与传统中心化交易所（如 Binance、Coinbase）类似，但去中心化版本存在许多问题。这些早期 DEX 的形态和面临的挑战包括：

**1.1.基于订单簿的去中心化交易所（Order Book DEX）**

- 概述：基于订单簿的去中心化交易所类似于传统金融市场，交易是通过买单和卖单的匹配来实现的，买家和卖家分别设定他们愿意买入或卖出的价格和数量。
- 例子：早期的去中心化交易所如 EtherDelta 和 0x（最初的版本）都是基于订单簿的 DEX。

**1.2.特点**

- 订单簿管理：用户发布买卖订单，其他用户选择是否接受这些订单。买卖双方的需求会通过撮合系统进行匹配。
- 链上交易：每次订单发布或取消都需要链上操作，这使得交易速度较慢且费用较高。
- 流动性依赖：订单簿系统的流动性严重依赖于活跃的买卖双方。当交易活跃度低时，流动性不足，交易难以快速执行。

**1.3.问题与挑战**

- 低流动性：在去中心化的订单簿系统中，流动性分散，用户需要等待匹配订单的时间较长，导致成交不畅。
- 高费用和低效率：由于所有订单和匹配过程都在链上进行，每次操作都需要支付交易费（gas），使得效率低下，尤其是在网络繁忙时。
- 用户体验差：由于订单簿系统复杂且需要用户手动操作，用户体验不佳，尤其对于不熟悉交易的用户。

**1.4.链上订单簿 vs 链下订单簿**

- 链上订单簿：像 EtherDelta 这样的 DEX 将所有订单发布和管理都放在链上进行。这虽然实现了去中心化，但显著增加了交易成本和延迟。
- 链下订单簿：一些项目（如 0x 协议）尝试将订单簿管理放在链下，只将订单撮合结果放在链上。这种模型改善了交易速度和费用问题，但仍然依赖流动性提供者。

**1.5.Atomic Swap（原子交换）**

在订单簿 DEX 之外，另一种去中心化交易方式是原子交换（Atomic Swap），这种技术允许两方在不同的区块链之间直接交换资产，而无需中介。原子交换的早期尝试主要是针对比特币和其他区块链资产之间的交易，典型的例子有 Decred 和 Lightning Network 的原子交换。

**1.5.1.优点**

- 完全去中心化：原子交换不需要第三方托管资产，交易通过智能合约保证两方同时完成交换。
- 跨链交易：用户可以在不同的区块链之间进行直接的去中心化交易，而不需要中心化的交易所。

**1.5.2.问题与挑战：**

- 技术复杂性：原子交换的技术实现较为复杂，难以被普通用户采用。
- 流动性和交易速度：原子交换的交易速度较慢，且跨链资产的流动性有限。

**1.6.去中心化订单路由协议（如 0x 协议）**

0x 是一种去中心化的订单路由协议，旨在为 DEX 提供标准化的交易基础设施。0x 允许开发者创建自己的 DEX，使用链下订单簿和链上结算的混合模式来提高效率。

**1.6.1.优点：**

- 协议灵活性：0x 允许开发者基于其协议构建不同的 DEX，提供了很高的灵活性。
- 改善用户体验：通过将订单簿放在链下，减少了用户在链上发布和取消订单的费用。

**1.6.2.挑战：**

- 流动性分散：虽然 0x 协议标准化了 DEX 的构建，但流动性仍然分散在不同的平台上，无法形成强大的交易市场。

## 2. Uniswap V1

Uniswap 出现之前，去中心化交易所的主要模式是基于订单簿的模型，但由于这些 DEX 依赖活跃的买卖双方和链上操作，导致交易效率低、流动性不足，用户体验较差。Uniswap V1 的自动做市商（AMM）模型通过引入流动性池和定价算法，避免了这些问题，使得交易更流畅、用户体验更好，并为 DEX 带来了革命性变化。

Uniswap V1 是一个开创性的去中心化交易平台（DEX），基于以太坊区块链开发，于 2018 年 11 月推出。它是自动做市商（AMM）模型的第一个实际应用，允许用户无需中介直接在链上交易 ERC20 代币。Uniswap V1 的核心特点和机制如下：

**2.1.核心机制**

- 自动做市商（AMM）模型：Uniswap V1 不依赖于传统的订单簿交易模式，而是使用了自动做市商模型。该模型通过一个流动性池（Liquidity Pool）来实现交易，流动性提供者将等值的两种资产（例如 ETH 和某个 ERC20 代币）存入池中，并根据一个简单的公式 $x×y=kx \times y = kx×y=k$ 来维持价格平衡，保证市场的流动性。
- 流动性池（Liquidity Pool）：用户可以向流动性池提供资产，成为流动性提供者（LP）。作为回报，流动性提供者可以获得每笔交易的手续费（0.3%），该费用按比例分配给所有池中的流动性提供者。
- 无许可的交易和流动性提供：任何人都可以自由地在 Uniswap 上提供流动性或进行交易，无需许可或身份验证，这符合去中心化金融（DeFi）的理念。
- ETH 中心化的交易对：在 Uniswap V1 中，每一个流动性池都是基于 ETH 和某个 ERC20 代币进行的交易对。这意味着如果用户想要交换两种 ERC20 代币，必须先将第一种代币兑换成 ETH，再将 ETH 兑换为第二种代币。

**2.2.Uniswap V1 的限制**

- 集中于 ETH 的交易对：所有交易对必须涉及 ETH，无法直接交易两个 ERC20 代币。
- 有限的可扩展性：随着 DeFi 的发展，V1 的简化设计无法满足日益增长的需求。
- 用户界面和体验：早期的用户界面较为原始，且存在一定的用户体验门槛，尤其是对新用户来说。

# 二.自动做市商模型

自动做市商模型（Automated Market Maker, AMM）是一种无需传统订单簿撮合的去中心化交易方式，广泛应用于去中心化交易所（DEX）如 Uniswap、SushiSwap 和 Balancer 中。AMM 通过算法自动定价和管理流动性，使用户能够轻松交换代币。

## 1.流动性池

流动性池是 AMM 模型的基础，流动性提供者（Liquidity Providers, LP）将两种代币（通常是等值的代币）存入池中，供交易者使用。流动性池替代了传统的订单簿，成为买卖双方进行交易的市场。每个流动性池都是一对代币的组合，例如 ETH/DAI。流动性提供者通过将这两种代币存入流动性池来提供流动性，并在每次交易时收取一小部分交易费用。

## 2.定价公式

AMM 通过预定的算法来确定代币之间的价格。最常见的定价公式是 Uniswap 采用的 恒定乘积公式： x × y=k； 其中，x 和 y 是池中两种代币的数量，k 是一个常数（即在交易过程中保持不变的总流动性）。当用户买入或卖出其中一种代币时，另一个代币的数量会自动调整，以维持这个等式不变。这种算法保证了交易双方能够在任何时候进行代币交换。

## 3.无订单簿、无中介

AMM 模型中不存在传统意义上的买单和卖单，也不需要中介来匹配订单。交易者直接与流动性池进行交互，按照当前算法设定的价格进行代币交换。这大大简化了交易流程，也使得任何人都可以成为流动性提供者。

## 4.流动性提供者收益

流动性提供者通过为池子提供资金获得收益。每次交易会产生一笔手续费（例如 Uniswap V2 的 0.3%），这些手续费按比例分配给所有为该流动性池提供流动性的 LP。流动性提供者也会承担一定的无常损失（Impermanent Loss）风险。

## 5.无常损失

无常损失指的是当流动性提供者的代币在价格波动期间受到的损失。由于 AMM 的定价算法，LP 存入的代币可能会在市场价格变化时造成损失，尤其是当代币价格发生大幅波动时，这种损失会更加明显。然而，如果价格最终恢复到初始状态，无常损失会减少或消失。

## 6.流动性挖矿和激励

为了鼓励更多人向流动性池提供流动性，许多 AMM 协议提供额外的激励机制，如流动性挖矿（Liquidity Mining）。用户通过提供流动性不仅能赚取交易手续费，还可以获得协议的原生代币作为奖励。

## 7.自动做市商模型的优点：

- 去中心化和无许可性：任何人都可以为流动性池提供流动性或在池子中交易，无需许可或信任第三方。
- 流动性提高：流动性池的设计使得即便没有大量的主动买家和卖家，也可以确保流动性并为用户提供流畅的交易体验。
- 简化的用户体验：AMM 摆脱了复杂的订单簿和撮合系统，降低了用户的学习门槛。

## 8.自动做市商模型的挑战

- 无常损失：流动性提供者面临代币价格波动带来的无常损失，特别是在价格大幅变化时，这种损失可能超过交易费用收益。
- 资本效率较低：AMM 模型中需要较大的流动性池来支持大额交易，随着交易量的增长，这种资本效率的低下表现得更为明显。
- 滑点：交易过程中，如果交易量较大，相对于流动性池的规模，可能会引发滑点（Slippage），即实际成交价格与预期价格的差异。

## 9.示例：ETH/DAI 流动性池中的交易

假设在 Uniswap V2 上有一个 ETH/DAI 流动性池。该池中目前有以下储备：

- 100 ETH
- 40,000 DAI

根据 AMM 的 恒定乘积公式 x × y=k，其中 x 代表池中的 ETH 数量，y 代表 DAI 数量，公式如下：

100×40000=4000000

在这个例子中，恒定乘积 k为 4000000

**9.1.用户用 10 ETH 购买 DAI**

现在假设有一个用户想用 10 ETH 从这个流动性池中购买 DAI。根据 Uniswap 的定价算法，交易后 ETH 的数量将变为 110 ETH，而池中的 DAI 数量将自动减少，以保持恒定乘积 k 不变。

新状态下池中的 DAI 数量  y 可以通过以下公式计算：

110 × y=4000000

解出 y：

y = 4000000  /  110 = 36363.64 DAI

因此，用户将从流动性池中获得：

40,000−36,363.64=3636.36DAI

用户用 10 ETH 购买了 3636.36 DAI。

**9.2.价格滑点**

交易完成后，池中的 ETH 数量增加，DAI 数量减少，这意味着池中 ETH 的价格升高。用户实际获得的 3,636.36 DAI 相比交易前的价格出现了滑点，因为交易量较大相对于池的总规模来说，价格会发生较大变化。

**9.3.流动性提供者的收益**

在 Uniswap V2 中，每次交易都会收取 0.3% 的交易手续费。对于这笔交易，手续费如下：

10×0.003=0.03ETH

这笔手续费会按比例分配给为这个 ETH/DAI 流动性池提供流动性的流动性提供者。

**9.4.无常损失**

流动性提供者由于池中代币价格的变化，可能会产生无常损失。假设在这个例子中，ETH 的价格在用户交易前是 400 DAI/ETH，而在用户购买后，ETH 的价格升到了 403.64 DAI/ETH。这种价格波动可能导致流动性提供者在撤出流动性时，相比不参与池的情况下损失一部分潜在收益。

# 三.Vyper 语法简介

Vyper 是一种智能合约编程语言，专为以太坊虚拟机（EVM）设计，注重安全性、简洁性和可读性。Vyper 的设计目标是成为一种更简单、更加安全的语言，减少常见的安全漏洞，并限制复杂的功能。相比 Solidity，Vyper 语法更为简洁，易于理解，并且摒弃了一些可能导致代码复杂性和错误的特性。

## 1.Vyper 的特点

- 简洁的语法：Vyper 通过限制语言功能来保持代码简洁易读。
- 安全性：去掉了一些容易出现安全漏洞的特性，如循环、递归和函数重载等。
- 审计友好：Vyper 的目标之一是使智能合约更容易被人类审计。

## 2.Vyper 的基本语法

Vyper 的语法风格类似于 Python，它使用缩进来表示代码块的层次结构。

**2.1 变量声明**

在 Vyper 中，变量需要声明其类型。这与 Solidity 的隐式类型声明不同，Vyper 强制变量有明确的类型。

```text
# 声明一个整数变量
count: public(int128)

# 声明一个地址变量
owner: public(address)

# 声明一个 map（类似于 Solidity 中的 mapping）
balances: public(map(address, uint256))
```

**2.2 函数定义**

Vyper 使用 @external 或 @internal装饰器来标识外部或内部函数。外部函数可以被合约外部调用，而内部函数只能在合约内部调用。

```text
@external
def set_count(_count: int128):
    self.count = _count

@internal
def _add(x: int128, y: int128) -> int128:
    return x + y
```

- @external：用于声明外部可调用的函数。

- @internal：用于声明仅能在合约内部调用的函数。

- -> type：表示返回值的类型。

**2.3 常量**

Vyper 支持常量的声明，常量值一旦定义便不可更改。

```text
MAX_SUPPLY: constant(uint256) = 1000000
```

**2.4 状态变量的访问权限**

Vyper 中可以通过 public 修饰符使状态变量公开访问，这样会自动生成对应的 getter 函数。

```text
balance: public(uint256)
```

上述声明会自动生成 balance() 函数，使得外部可以查询该变量的值。

**2.5 事件（Events）**

Vyper 支持事件，用于在链上发出通知。

```text
event Transfer:
    _from: indexed(address)
    _to: indexed(address)
    _value: uint256
```

- indexed 关键词用于将事件参数索引化，使得它们可以在日志中被更有效地搜索到。

**2.6 条件控制**

Vyper 支持 if-else 条件控制语句。

```text
@external
def transfer(_to: address, _amount: uint256):
    if self.balances[msg.sender] >= _amount:
        self.balances[msg.sender] -= _amount
        self.balances[_to] += _amount
    else:
        raise "Insufficient balance"
```

- if 后跟条件，缩进的代码块是条件为 True 时执行的代码。
- raise 用于抛出错误信息，当条件不满足时，交易会失败。

**2.7 结构体（Structs）**

Vyper 支持结构体，类似于 Solidity 中的 struct，用于将多个数据聚合成一个类型。

```text
struct Person:
    name: String[64]
    age: int128

person: public(Person)
```

在上述例子中，Person 是一个结构体，包含了 name 和 age 两个字段。

**2.8 消息（msg）和交易（tx）对象**

Vyper 中的 msg 和 tx 对象类似于 Solidity。

```text
# 访问发送者地址
sender: address = msg.sender

# 访问交易发起者的以太坊余额
balance: uint256 = self.balance
```

**2.9 函数修饰符**

在 Vyper 中，函数修饰符（Function Modifiers）与 Solidity 的类似，但由于 Vyper 的设计理念侧重简洁和安全性，它并没有 Solidity 中专门的“修饰符”功能（例如 modifier 关键字）。不过，Vyper 仍然通过函数的装饰器（Decorator）实现了某些类似修饰符的功能，比如控制函数的访问权限、允许支付以太币等。以下是 Vyper 中常用的函数修饰符（装饰器）：

**2.9.1.@external**

@external 修饰符用于定义外部可调用的函数。这意味着合约外部的用户或其他智能合约可以调用带有 @external 装饰器的函数。

```text
@external
def set_value(_value: int128):
    self.value = _value
```

- 这是外部可调用函数的标志，相当于 Solidity 中的 external。

**2.9.2.@internal**

@internal 修饰符用于定义只能由合约内部调用的函数。这意味着只有该合约中的其他函数才能调用这个函数，而外部调用将无法访问它。

```text
@internal
def _add(x: int128, y: int128) -> int128:
    return x + y
```

- @internal修饰符使得函数的访问权限仅限于合约内部，相当于 Solidity 中的 internal。


**2.9.3.@payable**

@payable 修饰符允许一个函数接收以太币。带有 @payable 修饰符的函数可以接受发送到合约的以太币。

```text
@external
@payable
def deposit():
    self.balances[msg.sender] += msg.value
```

- @payable相当于 Solidity 中的 payable，表示该函数可以接收以太币。


**2.9.4.@view**

@view 修饰符用于声明该函数不会修改链上的状态（不会改变合约的存储）。带有@view 修饰符的函数仅用于读取链上数据，不会消耗 gas。

```text
@external
@view
def get_balance(_addr: address) -> uint256:
    return self.balances[_addr]
```

- @view修饰符相当于 Solidity 中的 view，表示函数仅读取数据而不修改状态。


**2.9.5.@pure**

@pure 修饰符用于声明该函数既不会读取合约的存储，也不会修改链上的状态。它只能使用函数输入参数进行计算或操作。

```text
@external
@pure
def multiply(a: int128, b: int128) -> int128:
    return a * b
```

- @pure修饰符类似于 Solidity 中的 pure，表示函数既不读取合约存储，也不修改状态。


**2.9.6.@nonpayable**

Vyper 中并没有直接的 @nonpayable修饰符，但默认情况下，任何没有 @payable修饰符的函数都会被视为非支付函数。如果你不希望函数接受以太币，只需不加 @payable即可。

```text
@external
def set_owner(_owner: address):
    self.owner = _owner
```

2.9.7.自定义逻辑的修饰符

Vyper 不支持像 Solidity 那样的自定义修饰符（modifier 关键字），不过你可以在每个函数内部实现自定义的权限控制或其他逻辑。例如，实现一个只有合约拥有者才能调用的函数：

```text
owner: public(address)

@external
def __init__():
    self.owner = msg.sender

@internal
def _only_owner():
    assert msg.sender == self.owner, "Not authorized"

@external
def set_new_owner(_new_owner: address):
    self._only_owner()
    self.owner = _new_owner
```

在这个例子中，_only_owner() 函数充当了自定义的权限检查修饰符。

## 3.与 Solidity 的区别

- 不支持循环：Vyper 不支持 for 和 while 循环，旨在减少复杂性，并防止 gas 消耗过多的情况。
- 不支持递归：递归的使用可能会导致堆栈深度超过限制，因此 Vyper 禁止递归调用。
- 没有函数重载：Vyper 不支持函数重载，每个函数名在合约中必须唯一。
- 无继承：为了保持简单性，Vyper 不支持继承，这减少了合约之间的依赖性。
- 可读性优先：Vyper 通过减少特性来优先提高代码的可读性，使得合约更容易被审计。

## 4.示例合约：简单的代币合约

以下是一个基于 Vyper 的简单 ERC20 代币合约示例：

```text
# ERC20 代币标准

name: public(String[64])
symbol: public(String[32])
decimals: public(uint256)
total_supply: public(uint256)

balances: public(map(address, uint256))
allowances: public(map(address, map(address, uint256)))

event Transfer:
    sender: indexed(address)
    receiver: indexed(address)
    amount: uint256

event Approval:
    owner: indexed(address)
    spender: indexed(address)
    amount: uint256

@external
def __init__(_name: String[64], _symbol: String[32], _decimals: uint256, _initial_supply: uint256):
    self.name = _name
    self.symbol = _symbol
    self.decimals = _decimals
    self.total_supply = _initial_supply
    self.balances[msg.sender] = _initial_supply

@external
def transfer(_to: address, _amount: uint256) -> bool:
    assert self.balances[msg.sender] >= _amount, "Insufficient balance"
    self.balances[msg.sender] -= _amount
    self.balances[_to] += _amount
    log Transfer(msg.sender, _to, _amount)
    return True

@external
def approve(_spender: address, _amount: uint256) -> bool:
    self.allowances[msg.sender][_spender] = _amount
    log Approval(msg.sender, _spender, _amount)
    return True

@external
def transferFrom(_from: address, _to: address, _amount: uint256) -> bool:
    assert self.allowances[_from][msg.sender] >= _amount, "Allowance exceeded"
    assert self.balances[_from] >= _amount, "Insufficient balance"
    self.allowances[_from][msg.sender] -= _amount
    self.balances[_from] -= _amount
    self.balances[_to] += _amount
    log Transfer(_from, _to, _amount)
    return True
```

## 5.总结

Vyper 提供了一种简单、安全的智能合约编写方式，其限制有助于减少潜在的安全漏洞并提高代码的可读性。尽管功能比 Solidity 更有限，但对于特定的应用场景，尤其是需要高度安全性的应用场景，Vyper 是一种非常有吸引力的选择。

# 四.UniSwap V1 源码解读

## 创建交易合约模板地址

![图像](../picture/UniSwapV1-1.png)

```text
exchangeTemplate: public(address)

@public
def initializeFactory(template: address):
    // 入参 模板合约地址
    assert self.exchangeTemplate == ZERO_ADDRESS
    assert template != ZERO_ADDRESS
    // 设置模板合约地址
    self.exchangeTemplate = template
```

## 创建新的交易合约

![图像](../picture/UniSwapV1-2.png)

```text
@public
def createExchange(token: address) -> address:
    // 校验入参不是零地址
    assert token != ZERO_ADDRESS
    // 校验模板合约地址不是零地址
    assert self.exchangeTemplate != ZERO_ADDRESS
    // 入参地址，在历史处理中，不存在
    assert self.token_to_exchange[token] == ZERO_ADDRESS
    // 根据模板合约地址，创建exchange
    exchange: address = create_with_code_of(self.exchangeTemplate)
    // 使用入参token，初始化Exchange
    Exchange(exchange).setup(token)
    // 在多个mapping中设置相关信息
    self.token_to_exchange[token] = exchange
    self.exchange_to_token[exchange] = token
    token_id: uint256 = self.tokenCount + 1
    self.tokenCount = token_id
    self.id_to_token[token_id] = token
    log.NewExchange(token, exchange)
    return exchange
    
// 在mapping中，可以通过token地址，获取到exchange地址
// 
```

## 添加流动性

![图像](../picture/UniSwapV1-3.png)

```text
// 在Vyper中，@payable 修饰符允许函数接收ETH。当用户调用带有 @payable 修饰符的函数时，
// ETH会自动从用户的地址转移到当前合约中。因此，在 addLiquidity 函数中，
// ETH是在用户调用该函数时自动转移到合约中的。

min_liquidity：用户期望的最小流动性代币数量。
max_tokens：用户愿意提供的最大代币数量。
deadline：交易的最后执行时间。
返回值：铸造的流动性代币数量。

@public
@payable
def addLiquidity(min_liquidity: uint256, max_tokens: uint256, deadline: timestamp) -> uint256:
    // 确保操作在结束时间前执行，入参的token都是正常的数据
    // 确保用户提供的最大代币数量和ETH数量大于0
    assert deadline > block.timestamp and (max_tokens > 0 and msg.value > 0)
    // 获取当前交易对的UNI代币总供应量
    total_liquidity: uint256 = self.totalSupply
    if total_liquidity > 0:
        // 处理已有流动性池的情况
        
        // 确保入参的最小流动性大于0
        assert min_liquidity > 0
        // 计算合约中的eth储备，需要减去用户入参的eth
        eth_reserve: uint256(wei) = self.balance - msg.value
        // 获取合约中当前的代币储备量
        token_reserve: uint256 = self.token.balanceOf(self)
        // 计算需要的代币数量，公式为 msg.value * token_reserve / eth_reserve + 1
        // 确保按当前ETH和代币的比例添加流动性。
        token_amount: uint256 = msg.value * token_reserve / eth_reserve + 1
        // 计算铸造的流动性代币数量，公式为 msg.value * total_liquidity / eth_reserve
        liquidity_minted: uint256 = msg.value * total_liquidity / eth_reserve
        // 确保最大代币数量和铸造的流动性数量满足条件
        assert max_tokens >= token_amount and liquidity_minted >= min_liquidity
        // 增加用户的UNI代币余额
        self.balances[msg.sender] += liquidity_minted
        // 设置合约的UNI代币总发行量
        self.totalSupply = total_liquidity + liquidity_minted
        // 从用户地址，转移token到当前合约中
        assert self.token.transferFrom(msg.sender, self, token_amount)
        // 记录添加流动性事件，用户转移了eth，token到当前合约中
        log.AddLiquidity(msg.sender, msg.value, token_amount)
        // 记录转账事件，从合约地址，转移了代币到用户地址中
        log.Transfer(ZERO_ADDRESS, msg.sender, liquidity_minted)
        // 返回初始流动性代币数量
        return liquidity_minted
    else:
        // 如果是当前交易对的第一笔交易
        
        assert (self.factory != ZERO_ADDRESS and self.token != ZERO_ADDRESS) and msg.value >= 1000000000
        // 确保工厂获取的交易所地址为当前合约
        assert self.factory.getExchange(self.token) == self
        // 定义一个参数，等于入参 max_tokens
        token_amount: uint256 = max_tokens
        // 初始化流动性 = 当前合约的eth数量
        initial_liquidity: uint256 = as_unitless_number(self.balance)
        // 当前交易对的uni代币的总供应量 = 初始化流动性
        self.totalSupply = initial_liquidity
        // 设置用户的UNI代币余额
        // 获得的UNI代币数量等于合约中持有的ETH数量
        self.balances[msg.sender] = initial_liquidity
        // 从用户地址，转移token到当前合约中
        assert self.token.transferFrom(msg.sender, self, token_amount)
        // 记录添加流动性事件，用户转移了eth，token到当前合约中
        log.AddLiquidity(msg.sender, msg.value, token_amount)
        // 记录转账事件，从合约地址，转移了代币到用户地址中
        log.Transfer(ZERO_ADDRESS, msg.sender, initial_liquidity)
        // 返回初始流动性代币数量
        return initial_liquidity
```

## 删除流动性

![图像](../picture/UniSwapV1-4.png)

```text
amount：用户希望移除的流动性代币（UNI）的数量。
min_eth：用户希望提取的最小ETH数量。
min_tokens：用户希望提取的最小代币数量。
deadline：交易的最后执行时间。

允许用户从流动性池中移除流动性，并按比例提取ETH和代币。通过一系列的验证和计算，确保用户能够获得预期的ETH和代币数量，
并且交易在指定的时间内完成

@public
def removeLiquidity(amount: uint256, min_eth: uint256(wei), min_tokens: uint256, deadline: timestamp) -> (uint256(wei), uint256):
    // 确保amount、min_eth、min_tokens大于0，并且当前时间小于deadline。
    assert (amount > 0 and deadline > block.timestamp) and (min_eth > 0 and min_tokens > 0)
    // 获取当前合约中总的UNI代币供应量
    total_liquidity: uint256 = self.totalSupply
    // 确保总的UNI供应量大于0
    assert total_liquidity > 0
    // 获取当前合约中持有的代币数量
    token_reserve: uint256 = self.token.balanceOf(self)
    // 根据用户移除的流动性代币数量，按比例计算提取的ETH数量
    eth_amount: uint256(wei) = amount * self.balance / total_liquidity
    // 根据用户移除的流动性代币数量，按比例计算提取的代币数量
    token_amount: uint256 = amount * token_reserve / total_liquidity
    // 确保提取的ETH和代币数量不低于用户期望的最小值
    assert eth_amount >= min_eth and token_amount >= min_tokens
    // 减少用户的UNI代币余额
    self.balances[msg.sender] -= amount
    // 更新总的UNI代币供应量
    self.totalSupply = total_liquidity - amount
    // 发送计算出的ETH数量给用户
    send(msg.sender, eth_amount)
    // 转移计算出的代币数量给用户
    assert self.token.transfer(msg.sender, token_amount)
    // 记录移除流动性事件
    log.RemoveLiquidity(msg.sender, eth_amount, token_amount)
    // 记录转账事件
    log.Transfer(msg.sender, ZERO_ADDRESS, amount)
    return eth_amount, token_amount
```

## getInputPrice

根据恒定乘积进行计算

```text
input_amount：用户提供的输入数量（代币或ETH）。
input_reserve：交易所中输入类型的储备数量（代币或ETH）。
output_reserve：交易所中输出类型的储备数量（代币或ETH）。

使用恒定乘积公式来计算在给定输入数量的情况下，可以获得的输出数量。
它考虑了交易手续费，并确保输入和输出储备大于0。
这个方法在代币交换过程中用于确定用户提供的输入（ETH或代币）可以换取多少输出（代币或ETH）。
@private
@constant
def getInputPrice(input_amount: uint256, input_reserve: uint256, output_reserve: uint256) -> uint256:
    // 确保输入和输出储备大于0
    assert input_reserve > 0 and output_reserve > 0
    // 计算包含手续费的输入数量。这里的997是为了考虑交易手续费（0.3%）
    input_amount_with_fee: uint256 = input_amount * 997
    // 计算分子 分子计算公式
    numerator: uint256 = input_amount_with_fee * output_reserve
    // 计算分母 这里的1000是为了放大数值，避免小数计算
    denominator: uint256 = (input_reserve * 1000) + input_amount_with_fee
    // 返回可以获得的输出数量
    return numerator / denominator
```

## getOutputPrice

根据恒定乘积进行计算

```text
output_amount：用户希望获得的输出数量（代币或ETH）。
input_reserve：交易所中输入类型的储备数量（代币或ETH）。
output_reserve：交易所中输出类型的储备数量（代币或ETH）。

// 使用恒定乘积公式来计算在给定输出数量的情况下，需要的输入数量。
// 它考虑了交易手续费，并确保输入和输出储备大于0。
// 在代币交换过程中用于确定用户需要提供多少输入（ETH或代币）才能获得指定数量的输出（代币或ETH）。
@private
@constant
def getOutputPrice(output_amount: uint256, input_reserve: uint256, output_reserve: uint256) -> uint256:
    // 确保输入和输出储备大于0
    assert input_reserve > 0 and output_reserve > 0
    // 计算分子
    // 这里的1000是为了放大数值，避免小数计算
    numerator: uint256 = input_reserve * output_amount * 1000
    // 计算分母
    // 这里的997是为了考虑交易手续费（0.3%）
    denominator: uint256 = (output_reserve - output_amount) * 997
    // 返回需要的输入数量
    // +1是为了向上取整，确保输入数量足够覆盖输出数量
    return numerator / denominator + 1
```

## 交易-ETH到代币

![图像](../picture/UniSwapV1-5.png)

```text
eth_sold：用户卖出的ETH数量。
min_tokens：用户希望买入的最小代币数量。
deadline：交易的最后执行时间。
buyer：买入代币的用户地址。
recipient：接收代币的地址。
返回值：买入的代币数量。

将用户卖出的ETH转换为代币，并将代币转移给指定的接收者。
通过一系列的验证和计算，确保用户能够获得预期的代币数量，并且交易在指定的时间内完成。

@private
def ethToTokenInput(eth_sold: uint256(wei), min_tokens: uint256, deadline: timestamp, buyer: address, recipient: address) -> uint256:
    // 校验入参
    assert deadline >= block.timestamp and (eth_sold > 0 and min_tokens > 0)
    // 获取当前合约中持有的代币数量
    token_reserve: uint256 = self.token.balanceOf(self)
    // 根据恒定乘积公式，卖出的ETH，ETH储备，代币储备，计算买入代币数量
    tokens_bought: uint256 = self.getInputPrice(as_unitless_number(eth_sold), as_unitless_number(self.balance - eth_sold), token_reserve)
    // 确保买入的代币数量不低于用户期望的最小值
    assert tokens_bought >= min_tokens
    // 将计算出的代币数量转移给接收者
    assert self.token.transfer(recipient, tokens_bought)
    // 记录代币购买事件，包含买家地址、卖出的ETH数量和买入的代币数量
    log.TokenPurchase(buyer, eth_sold, tokens_bought)
    // 返回买入的代币数量
    return tokens_bought
```

## 交易-代币到ETH

![图像](../picture/UniSwapV1-6.png)

```text
tokens_sold：用户卖出的代币数量。
min_eth：用户希望买入的最小ETH数量。
deadline：交易的最后执行时间。
buyer：卖出代币的用户地址。
recipient：接收ETH的地址。
返回值：买入的ETH数量（以wei为单位）。

将用户卖出的代币转换为ETH，并将ETH转移给指定的接收者。
通过一系列的验证和计算，确保用户能够获得预期的ETH数量，并且交易在指定的时间内完成

@private
def tokenToEthInput(tokens_sold: uint256, min_eth: uint256(wei), deadline: timestamp, buyer: address, recipient: address) -> uint256(wei):
    // 确保tokens_sold和min_eth大于0，并且当前时间小于等于deadline。
    assert deadline >= block.timestamp and (tokens_sold > 0 and min_eth > 0)
    // 获取当前合约中持有的代币数量
    token_reserve: uint256 = self.token.balanceOf(self)
    // 根据恒定乘积公式，卖出的代币数量，代币储备，ETH储备，计算买入ETH数量
    eth_bought: uint256 = self.getInputPrice(tokens_sold, token_reserve, as_unitless_number(self.balance))
    // 将买入的ETH数量转换为wei单位
    wei_bought: uint256(wei) = as_wei_value(eth_bought, 'wei')
    // 确保买入的ETH数量不低于用户期望的最小值
    assert wei_bought >= min_eth
    // 将计算出的ETH数量发送给接收者
    send(recipient, wei_bought)
    // 从买家地址转移卖出的代币数量到合约
    assert self.token.transferFrom(buyer, self, tokens_sold)
    // 记录ETH购买事件，包含买家地址、卖出的代币数量和买入的ETH数量
    log.EthPurchase(buyer, tokens_sold, wei_bought)
    return wei_bought
```

## 交易-代币1到代币2

![图像](../picture/UniSwapV1-7.png)

```text
tokens_sold：用户卖出的代币数量。
min_tokens_bought：用户希望买入的最小目标代币数量。
min_eth_bought：用户希望买入的最小ETH数量。
deadline：交易的最后执行时间。
buyer：卖出代币的用户地址。
recipient：接收目标代币的地址。
exchange_addr：目标交易所的地址。
返回值：买入的目标代币数量。

将用户卖出的代币转换为ETH，然后再将ETH转换为另一种代币，并将最终的代币转移给指定的接收者。
通过一系列的验证和计算，确保用户能够获得预期的目标代币数量，并且交易在指定的时间内完成

@private
def tokenToTokenInput(tokens_sold: uint256, min_tokens_bought: uint256, min_eth_bought: uint256(wei), deadline: timestamp, buyer: address, recipient: address, exchange_addr: address) -> uint256:
    // 确保tokens_sold、min_tokens_bought和min_eth_bought大于0，并且当前时间小于等于deadline。
    assert (deadline >= block.timestamp and tokens_sold > 0) and (min_tokens_bought > 0 and min_eth_bought > 0)
    // 确保 exchange_addr 有效且不等于当前合约地址
    assert exchange_addr != self and exchange_addr != ZERO_ADDRESS
    // 获取当前交易对中持有的代币数量
    token_reserve: uint256 = self.token.balanceOf(self)
    // 根据恒定乘积公式，卖出的代币数量、代币储备和ETH储备计算买入的ETH数量
    eth_bought: uint256 = self.getInputPrice(tokens_sold, token_reserve, as_unitless_number(self.balance))
    // 将计算出的ETH数量转换为wei单位
    wei_bought: uint256(wei) = as_wei_value(eth_bought, 'wei')
    // 确保买入的ETH数量不低于用户期望的最小值
    assert wei_bought >= min_eth_bought
    // 从买家地址转移卖出的代币数量到合约
    assert self.token.transferFrom(buyer, self, tokens_sold)
    // 调用目标交易所的ethToTokenTransferInput函数，将ETH转换为目标代币并转移给接收者
    tokens_bought: uint256 = Exchange(exchange_addr).ethToTokenTransferInput(min_tokens_bought, deadline, recipient, value=wei_bought)
    // 记录ETH购买事件，包含买家地址、卖出的代币数量和买入的ETH数量
    log.EthPurchase(buyer, tokens_sold, wei_bought)
    return tokens_bought
```

# 五.总结

下图展示了Uniswap V1 智能合约的基本架构和交易流程：

![图像](../picture/UniSwapV1-8.png)

**uniswap_factory.vy**：这是一个工厂合约，负责创建新的交易合约（exchange）。每个交易合约对应一个特定的代币对。

**uniswap_exchange.vy**：这是交易合约的核心，处理所有交易相关的逻辑，主要功能分为：

- 添加流动性（流动池充值）
- 删除流动性（流动池提取）
- 交换功能，包括： 
  - **ETH兑Token**：用户可以将以太坊（ETH）兑换成其他代币。 
  - **Token兑ETH**：用户可以将持有的代币兑换成以太坊。 
  - **Token兑Token**（通过以太坊作为中介）：用户可以将一种代币直接兑换成另一种代币，通过中间的以太坊转换。