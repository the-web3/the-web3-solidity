# UniSwap V2 底层原理和代码详解解读

# 一. **Uniswap V2 相对于 V1 的变化**

**Uniswap V2** 是 Uniswap 去中心化交易所的第二个版本，发布于 2020 年 5 月。与其前身 Uniswap V1 相比，V2 引入了一些显著的改进和新功能，提升了流动性提供、交易效率以及用户体验。

## 1.**合约代码用 solidity 重构**

- Uniswap V1 合约是用 Vyper 写的，Uniswap V2 用 solidity 重写了

## 2.**ERC20 到 ERC20 交易对**

- 在 Uniswap V1 中，每个交易对都必须包含以太坊（ETH）作为中介，意味着 ERC20 代币之间的交易需要通过 ETH 进行两步交换：从 ERC20 转换为 ETH，再从 ETH 转换为另一种 ERC20 代币。
- Uniswap V2 支持 **ERC20 到 ERC20** 直接交易，这不仅简化了交易流程，还减少了交易手续费和滑点。

## 3.**闪电交换（Flash Swaps）**

- **闪电交换** 允许用户无需预先支付代币即可借出合约中的任意数量的资产，只要在交易结束前支付相应的代币，或在交易过程中销毁代币。
- 这种机制类似于 Aave 或 dYdX 的闪电贷，用户可以在单个原子交易中借入和偿还资产，极大地提升了去中心化金融（DeFi）的创新能力。

## 4.**TWAP**

- Uniswap V2 中引入了内置的 **时间加权平均价格（TWAP）预言机** 功能。这使得开发者可以通过调用 Uniswap 合约获取价格信息，用于其他去中心化应用（Dapps）中，如借贷协议、衍生品等。
- TWAP 价格计算基于一定时间段内的价格均值，能够抵抗短期波动和攻击，增强了系统的稳健性。

## 5.增加了统一入口 Router 合约

- Uniswap V2 的入口在 Router 合约

## 6.**可定制的智能合约架构**

- Uniswap V2 的合约架构更加模块化和灵活，支持自定义 LP 代币、手续费模型等功能。这使得开发者可以基于 Uniswap V2 创建更加复杂的金融工具和服务。

## 7.**安全性增强**

- Uniswap V2 通过升级合约架构来增强安全性，包括更强的输入验证、更好的防止重入攻击机制等，减少了潜在的智能合约漏洞。

# 二. Uniswap V2 的工作原理

Uniswap V2 基本上仍然遵循自动做市商（AMM）的模型，核心概念是通过一个恒定的产品公式（x * y = k）来确保流动性池中的代币之间的比例平衡：

- x 和 y 代表流动性池中两种代币的数量。
- k 是一个恒定的值，保持不变。

当用户进行交易时，他们向流动性池中增加一种代币并移除另一种代币，这会改变代币之间的比例，自动调整交易价格。

## 1.流动性提供者（LP）

- LP 在 Uniswap 中扮演关键角色，他们通过提供流动性（即存入一对代币）来支持交易池的运行，并获得交易手续费。
- Uniswap V2 中的 LP 会收到相应的 **ERC20 LP 代币**，这些代币代表他们在池中的股份。LP 可以随时撤回流动性并销毁 LP 代币，以赎回他们存入的资产及交易手续费。

## 2.手续费模型

- Uniswap V2 中的每笔交易会向流动性提供者收取 **0.30%** 的手续费，这部分手续费会按比例分配给池中的所有 LP。
- 同时，Uniswap V2 也引入了一个未来可以激活的手续费切换功能，协议可选择将 0.05% 的手续费分配给 Uniswap 协议的治理合约。

# 三.Uniswap V2 合约结构

Uniswap V2 的核心智能合约组件如下：

- **Factory 合约**：负责创建和管理交易对（每个交易对对应一个流动性池合约）。
- **Pair 合约**：每个交易对都有一个 Pair 合约，负责管理特定代币对的流动性、交易和闪电兑换。
- **Router 合约**：负责管理用户交互，帮助用户完成代币之间的交换和流动性添加/移除等操作。

# 四.Uniswap V2 的局限性

虽然 Uniswap V2 具有显著的改进，但它仍然面临一些问题：

- **高 Gas 费**：在以太坊主网上运行时，Uniswap V2 交易的 Gas 成本可能会很高，尤其是在以太坊网络拥堵的情况下。
- **滑点问题**：由于恒定乘积公式，价格滑点可能较大，尤其是在流动性不足的情况下。
- **无常损失**：流动性提供者面临无常损失的风险，当价格波动较大时，提供流动性可能会导致 LP 损失部分价值。

# 五.Uniswap V2 代码库介绍

- interface
- v2-sdk
- sdk-core
- info
- v2-subgraph
- v2-periphery
- solidity-lib

Interface,  v2-sdk 和 sdk-core 都是前端的项目，对应 uniswap 的网页，展示页面在 interface 项目中，v2-sdk 和 sdk-core 则是做为 sdk 存在。

info 是 Uniswap 的数据分析项目，展示数据分析，主要是从 supgraph 里面的读取数据，也就是 v2-subgraph 项目

最后三个则是合约项目了，v2-core 就是核心合约的实现; v2-periphery 则提供了和 UniswapV2 进行交互的外围合约，主要就是路由合约; solidity-lib 则封装了一些工具合约。core和 periphery 里的合约实现是我们后面要重点讲解的内容。

另外，UniswapV2 其实还有一个流动性挖矿合约项目 liquidity-staker ，因为UniswapV2 的流动性挖矿只上线过一段短暂的时间，很少人知道这个项目，但是这个项目也是值得学习。

![图像](../picture/UniSwapV2-1.png)

# 六.Uniswap V2 代码详解

## 1.v2-Core 合约代码文件

- UniswapV2ERC20： LP Token 合约
- UniswapV2Factory： 工厂合约
- UniswapV2Pair：配对合约：UniswapV2Pair 合约里面有三个核心的函数：mint(), burn() 和 swap(), 分别为添加流动性，移除流动性和兑换三个底层操作函数。

## 2.v2-periphery 合约代码文件

- UniswapV2Migrator：V1 迁移到 V2 的合约代码文件
- UniswapV2Router0: 路由合约，合约的入口文件

## 3. 创建交易对

配对合约管理着流动性资金池，不同币对有着不同的配对合约实例，比如 USDT-WETH这一个币对，就对应一个配对合约实例，DAI-WETH 又对应另一个配对合约实例。

每个配对合约都有对应的一种 LP Token 与之绑定。其实，UniswapV2Pair 继承了UniswapV2ERC20，所以配对合约本身其实也是 LP Token 合约。

工厂合约则是用来部署配对合约的，通过工厂合约的 createPair() 函数来创建新的配对合约实例。

![图像](../picture/UniSwapV2-2.png)

## 4.添加流动性

![图像](../picture/UniSwapV2-3.jpg)

## 5.移除流动性

![图像](../picture/UniSwapV2-4.jpg)

## 6.兑换

![图像](../picture/UniSwapV2-5.jpg)

**6.1.Swap 函数详解**

swap 有 4个入参; amount0Out 和 amount1Out 表示兑换结果要转出的 token0 和token1 的数量，这两个值通常情况下是一个为 0,一个不为 0，但使用闪电交易时可能两个都不为 0。to 参数则是接收者地址，最后的 data参数是执行回调时的传递数据，通过路由合约兑换的话，该值为 0。

第一步先校验兑换结果的数量是否有一个大于 0，然后读取出两个代币的 reserve,，之后再校验兑换数量是否小于 reserve

```text
{ // scope for _token{0,1}, avoids stack too deep errors
address _token0 = token0;

address _token1 = token1;

require(to != _token0 && to != _token1, 'UniswapV2: INVALID_TO');

if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);

balance0 = IERC20(_token0).balanceOf(address(this));

balance1 = IERC20(_token1).balanceOf(address(this));

}
```

用了一对大括号，这主要是为了限制 token{0,1} 这两个临时变量的作用域，防止堆栈太深导致错误。

接着，就开始将代币划转到接收者地址了。

如果 data 参数长度大于 0，则将 to 地址转为 IUniswapV2Callee并调用其uniswapV2Call()函数，这其实就是一个回调函数，to 地址需要实现该接口。

```text
if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);
```

然后获取两个代币当前的余额 balance{0,1}而这个余额是扣减了转出代币后的余额。

计算出实际转入的代币数量了。实际转入的数量其实也通常是一个头0，一个不为 0 的。要理解计算公式的原理，我举一个实例来说明。

假设转入的是 token0，转出的是 token1，转入数量为 100，转出数量为 200。那么，下面几个值将如下:

```text
amount0Outln =100
amount1ln=0
amount0Out =0
amount1Out=200
```

而 reserve0 和 reserve1 假设分别为 1000 和 2000，没进行兑换交易之前，balance{0,1}和 reserve{0,1} 是相等的。而完成了代币的转入和转出之后，其实，balance0 就变成了1000+100-0=1100，balance1 变成了 2000+0-200=1800。整理成公式则如下:

```text
balance0 =reserve0 + amountOin -amoutOOui

balance1= reserve1 + amountlIn-amout1Out
```

反推一下就得到:

```text
amountin =balance-(reserve- amountOut)
```

## 7.闪电兑换

**7.1.Uniswap V2 闪电兑换概述**

Uniswap V2 中的 闪电兑换（Flash Swap）是一种强大的功能，允许用户无需提前准备资产即可执行代币兑换，并且只要在同一笔交易中偿还所借资产或等价资产，用户就不需要支付抵押。这一功能是 Uniswap V2 的扩展，相当于允许用户从流动性池中临时借出资金，用于套利、抵押或其他复杂的 DeFi 操作。

从代码层面来说，闪电兑换的触发在 UniswapV2Pair 合约的 swap 函数里的，该函数里有这么一行代码:

```text
if (data.length >0) lUniswapV2Callee(to).uniswapV2Cal(msg.sender, amountOOut, amount1Out, data);
```

这行代码主要说明了三个信息:

- to 地址是一个合约地址
- to 地址的合约实现了 IUniswapV2Callee 接口
- 可以在 uniswapV2Call 函数里执行 to 合约自己的逻辑

般情况下的兑换流程，是先支付 tokenA 再得到 tokenB 但闪电兑换却可以先得到 tokenB 最后再支付 tokenA。如下图:

![图像](../picture/UniSwapV2-6.jpg)

**7.2.闪电兑换流程**

**7.2.1.借出代币**

用户调用 swap 函数时，可以借出 amount0Out 和/或 amount1Out 数量的代币。此时，用户无需提前提供资金抵押，但必须在同一笔交易内通过回调函数 UniswapV2Call 来完成相应的操作。

```text
pair.swap(amount0Out, amount1Out, to, data);
```

- 如果 data 不为空，Uniswap V2 会理解为这是一次闪电兑换，并在取出代币后调用用户实现的回调函数 UniswapV2Call。

**7.2.2 回调函数 UniswapV2Call**

当 swap 函数被执行并检测到 data 不为空时，合约会调用一个回调函数 UniswapV2Call，允许用户在这个过程中执行自定义逻辑。这就是闪电兑换的核心步骤。

```text
function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external {
    // 执行自定义的闪电兑换逻辑
}
```

- **sender**: 交易的发起者地址。
- **amount0**: 借出的 token0 的数量。
- **amount1**: 借出的 token1 的数量。
- **data**: 交易时传入的自定义数据（通常包含额外的逻辑指令）。

**7.2.3 偿还借款**

在 uniswapV2Call 回调中，用户可以执行任何复杂的逻辑，比如在其他交易所套利、借贷、清算等操作。然而，在交易结束时，用户必须确保按照 Uniswap 的恒定乘积公式偿还所借代币：

- **直接偿还借款**：用户可以通过将借出的代币在回调中直接发送回 Uniswap 流动性池来完成闪电兑换。
- **以另一种代币偿还**：用户可以通过使用借来的代币在同一笔交易中在其他地方兑换出另一种代币，然后用该代币偿还流动性池。例如，如果用户借出的是 token0，那么他们可以在回调中卖掉 token0 兑换成 token1，并偿还 token1。

偿还借款时，还需要支付 0.3% 的手续费。如果没有按照要求偿还所借代币，整个交易会回滚。

**7.2.4.恒定乘积校验**

在交易结束时，Uniswap 会自动检查流动性池中的代币数量是否满足 x * y = k 的恒定乘积公式。如果满足条件，交易才会成功。如果用户未能在交易内偿还代币，交易将回滚，之前的操作无效。

**7.2.5.Uniswap v2 闪电兑换案例**

```text
pragma solidity =0.6.6;

import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Callee.sol';

import '../libraries/UniswapV2Library.sol';
import '../interfaces/V1/IUniswapV1Factory.sol';
import '../interfaces/V1/IUniswapV1Exchange.sol';
import '../interfaces/IUniswapV2Router01.sol';
import '../interfaces/IERC20.sol';
import '../interfaces/IWETH.sol';

contract ExampleFlashSwap is IUniswapV2Callee {
    IUniswapV1Factory immutable factoryV1;
    address immutable factory;
    IWETH immutable WETH;

    constructor(address _factory, address _factoryV1, address router) public {
        factoryV1 = IUniswapV1Factory(_factoryV1);
        factory = _factory;
        WETH = IWETH(IUniswapV2Router01(router).WETH());
    }

    // needs to accept ETH from any V1 exchange and WETH. ideally this could be enforced, as in the router,
    // but it's not possible because it requires a call to the v1 factory, which takes too much gas
    receive() external payable {}

    // gets tokens/WETH via a V2 flash swap, swaps for the ETH/tokens on V1, repays V2, and keeps the rest!
    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external override {
        address[] memory path = new address[](2);
        uint amountToken;
        uint amountETH;
        { // scope for token{0,1}, avoids stack too deep errors
        address token0 = IUniswapV2Pair(msg.sender).token0();
        address token1 = IUniswapV2Pair(msg.sender).token1();
        assert(msg.sender == UniswapV2Library.pairFor(factory, token0, token1)); // ensure that msg.sender is actually a V2 pair
        assert(amount0 == 0 || amount1 == 0); // this strategy is unidirectional
        path[0] = amount0 == 0 ? token0 : token1;
        path[1] = amount0 == 0 ? token1 : token0;
        amountToken = token0 == address(WETH) ? amount1 : amount0;
        amountETH = token0 == address(WETH) ? amount0 : amount1;
        }

        assert(path[0] == address(WETH) || path[1] == address(WETH)); // this strategy only works with a V2 WETH pair
        IERC20 token = IERC20(path[0] == address(WETH) ? path[1] : path[0]);
        IUniswapV1Exchange exchangeV1 = IUniswapV1Exchange(factoryV1.getExchange(address(token))); // get V1 exchange

        if (amountToken > 0) {
            (uint minETH) = abi.decode(data, (uint)); // slippage parameter for V1, passed in by caller
            token.approve(address(exchangeV1), amountToken);
            uint amountReceived = exchangeV1.tokenToEthSwapInput(amountToken, minETH, uint(-1));
            uint amountRequired = UniswapV2Library.getAmountsIn(factory, amountToken, path)[0];
            assert(amountReceived > amountRequired); // fail if we didn't get enough ETH back to repay our flash loan
            WETH.deposit{value: amountRequired}();
            assert(WETH.transfer(msg.sender, amountRequired)); // return WETH to V2 pair
            (bool success,) = sender.call{value: amountReceived - amountRequired}(new bytes(0)); // keep the rest! (ETH)
            assert(success);
        } else {
            (uint minTokens) = abi.decode(data, (uint)); // slippage parameter for V1, passed in by caller
            WETH.withdraw(amountETH);
            uint amountReceived = exchangeV1.ethToTokenSwapInput{value: amountETH}(minTokens, uint(-1));
            uint amountRequired = UniswapV2Library.getAmountsIn(factory, amountETH, path)[0];
            assert(amountReceived > amountRequired); // fail if we didn't get enough tokens back to repay our flash loan
            assert(token.transfer(msg.sender, amountRequired)); // return tokens to V2 pair
            assert(token.transfer(sender, amountReceived - amountRequired)); // keep the rest! (tokens)
        }
    }
}
```

## 8.LP Token 质押

Uniswap 的 **liquidity-staker** 合约用于激励流动性提供者（LPs），允许他们质押 Uniswap 的流动性代币（LP 代币）以获得额外的奖励。这是通过一个 **质押奖励机制** 实现的，用户可以将 LP 代币存入合约中，并根据质押时间获得奖励代币。

**8.1.代码解读**

- **质押 (stake)**：用户可以将 Uniswap V2 的 LP 代币质押到合约中。通过调用 stake 函数，用户提供的代币会被锁定在合约内，并且开始累积奖励。

```
function stake(uint256 amount) external nonReentrant updateReward(msg.sender);
```



- **奖励累积 (rewardPerToken 和 earned)**： rewardPerToken 计算每个 LP 代币可以获得的奖励代币数量。 earned 则计算某个用户可以领取的奖励数量。

```
function rewardPerToken() public view returns (uint256); 
function earned(address account) public view returns (uint256);
```



- **提取质押与奖励 (withdraw 和 getReward)**： withdraw：用户可以提取部分或全部质押的 LP 代币。 getReward：用户可以领取累计的奖励代币。

```
function withdraw(uint256 amount) public nonReentrant updateReward(msg.sender); 
function getReward() public nonReentrant updateReward(msg.sender);
```



- **退出 (exit)**：退出操作可以让用户同时提取质押的代币并领取所有奖励。

```
function exit() external;
```



- **奖励通知 (notifyRewardAmount)**：项目方可以调用该函数来设置或调整奖励分发的额度和速率。

```
function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution;
```



**8.2.流程概述**

- **质押代币**：用户首先质押 LP 代币到合约中，开始参与奖励计划。
- **累积奖励**：根据用户质押的时间和数量，奖励代币会逐步累积。
- **领取奖励**：用户可以随时提取奖励，并在需要时撤回质押的代币。

# 七.Uniswap V2 发展总结

Uniswap V2 的发布推动了去中心化交易（DEX）的发展，增强了 DeFi 生态系统中的流动性，但随着 Uniswap V3 的推出，V2 已逐渐成为 V3 的基础版本，V3 引入了更多功能，如集中的流动性和更灵活的费率模型。