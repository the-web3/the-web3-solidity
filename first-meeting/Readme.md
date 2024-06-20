# 初识 Solidity 编程语言

## 一. 简介
Solidity 是一种面向智能合约的高级编程语言，主要用于在以太坊（Ethereum）区块链平台上开发和部署智能合约。Solidity 由以太坊创始团队开发，旨在简化智能合约的创建和管理，Solidit 语言有以下这些主要的特点。

- 面向合约编程：Solidity 专为编写智能合约设计，这些合约运行在以太坊虚拟机（EVM）上，自动执行和管理区块链上的交易和协议。
- 静态类型：Solidity 是一种静态类型语言，变量类型在编译时确定，提供了更严格的类型检查和更高的代码安全性。
- 合约继承：Solidity 支持合约继承，允许开发者创建可重用的合约组件，从而简化代码结构和提高代码的可维护性。
- 库和接口：Solidity 提供了库和接口功能，帮助开发者模块化代码，提高代码的重用性和可维护性。
- 事件和日志：Solidity 支持事件和日志功能，可以在合约执行过程中生成日志记录，方便在区块链上进行事件追踪和调试。
- 访问控制和权限管理：Solidity 提供了灵活的访问控制机制，可以定义不同的访问权限和角色，确保合约的安全性。

## 二. 合约文件结构
这里我们直接看一个真实项目的标准的合约合约文件，L2RewardManager 是这个合约的名称，该合约继承了  L2Base, L2RewardManagerStorage， L2RewardManager 合约的常量，事件和错误类型都定义到了 L2RewardManagerStorage 文件里面了。

```
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;


import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {L2RewardManagerStorage} from "@/contracts/l2/core/L2RewardManagerStorage.sol";
import {L2Base} from "@/contracts/l2/core/L2Base.sol";

contract L2RewardManager is L2Base, L2RewardManagerStorage {
    using SafeERC20 for IERC20;
    uint256 public stakerPercent = 92;

    constructor(){
        _disableInitializers();
    }

    function initialize(
        address initialOwner
    ) external initializer {
        __L2Base_init(initialOwner);
    }

    function calculateFee(address strategy, address operator, uint256 baseFee) external {
        uint256 totalShares = getStrategy(strategy).totalShares();
        uint256 operatorShares = getDelegationManager().operatorShares(operator, strategy);
        uint256 operatorTotalFee = baseFee / (operatorShares / totalShares);

        uint256 stakerFee = operatorTotalFee * (stakerPercent / 100);
        stakerRewards[strategy] = stakerFee;

        uint256 operatorFee = operatorTotalFee * ((100 - stakerPercent) / 100);
        operatorRewards[operator] = operatorFee;

        emit OperatorStakerReward(
            strategy,
            operator,
            stakerFee,
            operatorFee
        );
    }

    function depositDappLinkToken(uint256 amount) external returns (bool){
        getDapplinkToken().safeTransferFrom(msg.sender, address(this), amount);
        emit DepositDappLinkToken(msg.sender, amount);
        return true;
    }

    function operatorClaimReward() external returns (bool){
        uint256 claimAmount = operatorRewards[msg.sender];
        getDapplinkToken().safeTransferFrom(address(this), msg.sender, claimAmount);
        emit OperatorClaimReward(
            msg.sender,
            claimAmount
        );
        return true;
    }

    function stakerClaimReward(address strategy) external returns (bool){
       uint256 stakerAmount = stakerRewardsAmount(strategy);
        getDapplinkToken().safeTransferFrom(address(this), msg.sender, stakerAmount);
        emit StakerClaimReward(
            msg.sender,
            stakerAmount
        );
        return true;
    }

    function stakerRewardsAmount(address strategy) public view returns (uint256){
        uint256 stakerShare = getStrategyManager().getStakerStrategyShares(msg.sender, strategy);
        uint256 strategyShares = getStrategy(strategy).totalShares();
        if (stakerShare == 0 ||strategyShares == 0) {
            return 0;
        }
        return stakerRewards[strategy] * (stakerShare /  strategyShares);
    }

    function updateOperatorAndStakerShareFee(uint256 _stakerPercent) external {
         stakerPercent = _stakerPercent;
    }
}
```

## 合约文件详细解释

- 版本声明：这是合约的版本声明，指定合约使用的 Solidity 编译器版本。

```
pragma solidity ^0.8.24;
```

- 导入声明：如果合约依赖于其他文件或库，可以使用 import 语句导入。
```
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {L2RewardManagerStorage} from "@/contracts/l2/core/L2RewardManagerStorage.sol";
import {L2Base} from "@/contracts/l2/core/L2Base.sol";
```
- 合约声明: 使用 contract 关键字声明一个新合约，合约的主体内容放在大括号内。
- 合约继承：使用 is  后面跟其他合约名称表示继承
```
contract L2RewardManager is L2Base, L2RewardManagerStorage {
}
```
- 状态变量：状态变量是存储在区块链上的变量，合约中可以访问和修改这些变量。 public 关键字表示这些变量可以从外部读取。
```
uint256 public stakerPercent = 92;
```

- 常量：
```  
bytes32 public constant STAKING_MANAGER_ROLE = keccak256("STAKING_MANAGER_ROLE");
```

- 事件：事件是 EVM 日志的一种便捷接口，前端应用可以监听这些事件。
```
event OperatorStakerReward(
    address strategy,
    address operator,
    uint256 stakerFee,
    uint256 operatorFee
);
```

- 修饰符：修饰符用于修改函数的行为，这里 onlyStrategyManager 修饰符确保只有合约的拥有者才能调用某些函数。
```
modifier onlyStrategyManager() {
    require(msg.sender == address(strategyManager), "StrategyBase.onlyStrategyManager");
    _;
}
```
- 构造函数：构造函数在合约部署时执行，用于初始化状态变量。
```
constructor(){
    _disableInitializers();
}
```

- 初始化函数: 参数初始化，函数职能执行一次
```
function initialize(
    address initialOwner
) external initializer {
    __L2Base_init(initialOwner);
}
```

- 函数：一个计算 operator cliam 奖励的函数

```
function operatorClaimReward() external returns (bool){
    uint256 claimAmount = operatorRewards[msg.sender];
    getDapplinkToken().safeTransferFrom(address(this), msg.sender, claimAmount);
    emit OperatorClaimReward(
        msg.sender,
        claimAmount
    );
    return true;
}
```

- 错误定义：0 地址是抛出这个错误
```
error ZeroAddress();
```

上面解释加了一个我们 L2RewardManager 合约里面没有用到的东西。

## 三. 合约定义
在 Solidity 中，定义合约包括声明合约的名称、设置合约的状态变量、编写函数和事件等。 L2RewardManager 是一个详细的合约定义示例，我们上面也简单解释了这个合约。
