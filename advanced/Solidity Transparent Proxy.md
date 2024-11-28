# Solidity 智能合约透明代理升级实战

# 1.代理升级模式

代理升级模式包括不同的实现方式，主要有透明代理、UUPS 代理和 Beacon 代理。每种模式都有其特点和适用场景，本文我们来给大家讲解透明代理升级的特点与实战

# 2.透明代理简介与特点

透明代理模式利用两个合约——代理合约和逻辑合约。代理合约负责管理对逻辑合约的调用，并可以进行升级。透明代理模式中，代理合约和逻辑合约之间的交互通过 delegatecall 实现，且合约的逻辑和存储被分离开来；透明代理升级具有以下特点：

- 代理合约可以被升级，但原始合约地址不变。
- 需要管理员权限来执行合约的升级。
- 透明代理模式简单易用，但升级的管理可能会带来一些安全隐患（如合约被误升级等）。

# 3.透明代理升级实战代码-社区任务赏金管理合约

## 3.1合约逻辑

- 项目方可以往合约里面充值 ETH 或者其他 ERC20 Token
- 社区成员完成一个任务之后，链下服务会触发向任务管理合约提交该任务的赏金
- 社区成员可以从合约里面 cliam 自己的赏金
- 项目可以从合约里面提取 ETH 或者是 ERC20 Token

## **3.2.代码**

**3.2.1.interfaces 代码**

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ITreasureManager {
    function depositETH() external payable returns (bool);
    function depositERC20(IERC20 tokenAddress, uint256 amount) external returns (bool);
    function grantRewards(address tokenAddress, address granter, uint256 amount) external;
    function claimAllTokens() external;
    function claimToken(address tokenAddress) external;
    function withdrawETH(address payable withdrawAddress, uint256 amount) external payable returns (bool);
    function withdrawERC20(IERC20 tokenAddress, address withdrawAddress, uint256 amount) external returns (bool);
    function setTokenWhiteList(address tokenAddress) external;
    function setWithdrawManager(address _withdrawManager) external;
    function queryReward(address _tokenAddress) external view returns (uint256);
    function getTokenWhiteList() external view returns (address[] memory);
}
```

**3.2.2.合约代码**

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./ITreasureManager.sol";

contract  TreasureManager is Initializable, AccessControlUpgradeable, ReentrancyGuardUpgradeable, OwnableUpgradeable, ITreasureManager {
    using SafeERC20 for IERC20;

    address public constant ethAddress = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

    address public treasureManager;
    address public withdrawManager;

    address[] public tokenWhiteList;

    mapping(address => uint256) public tokenBalances;
    mapping(address => mapping(address => uint256)) public userRewardAmounts;

    error IsZeroAddress();

    event DepositToken(
        address indexed tokenAddress,
        address indexed sender,
        uint256 amount
    );

    event WithdrawToken(
        address indexed tokenAddress,
        address sender,
        address withdrawAddress,
        uint256 amount
    );

    event GrantRewardTokenAmount(
        address indexed tokenAddress,
        address granter,
        uint256 amount
    );

    event WithdrawManagerUpdate(
        address indexed withdrawManager
    );


    modifier onlyTreasureManager() {
        require(msg.sender == address(treasureManager), "TreasureManager.onlyTreasureManager");
        _;
    }

    modifier onlyWithdrawManager() {
        require(msg.sender == address(withdrawManager), "TreasureManager.onlyWithdrawer");
        _;
    }


    function initialize(address _initialOwner, address _treasureManager, address _withdrawManager) public initializer {
        treasureManager = _treasureManager;
        withdrawManager = _withdrawManager;
        _transferOwnership(_initialOwner);
    }

    receive() external payable {
        depositETH();
    }
    
    function depositETH() public payable nonReentrant returns (bool) {
        tokenBalances[ethAddress] += msg.value;
        emit DepositToken(
            ethAddress,
            msg.sender,
            msg.value
        );
        return true;
    }

    function depositERC20(IERC20 tokenAddress, uint256 amount) external returns (bool) {
        tokenAddress.safeTransferFrom(msg.sender, address(this), amount);
        tokenBalances[address(tokenAddress)] += amount;
        emit DepositToken(
            address(tokenAddress),
            msg.sender,
            amount
        );
        return true;
    }

    function grantRewards(address tokenAddress, address granter, uint256 amount) external onlyTreasureManager {
        require(address(tokenAddress) != address(0) && granter != address(0), "Invalid address");
        userRewardAmounts[granter][address(tokenAddress)] += amount;
        emit GrantRewardTokenAmount(address(tokenAddress), granter, amount);
    }
    
    function claimAllTokens() external {
        for (uint256 i = 0; i < tokenWhiteList.length; i++) {
            address tokenAddress = tokenWhiteList[i];
            uint256 rewardAmount = userRewardAmounts[msg.sender][tokenAddress];
            if (rewardAmount > 0) {
                if (tokenAddress == ethAddress) {
                    (bool success, ) = msg.sender.call{value: rewardAmount}("");
                    require(success, "ETH transfer failed");
                } else {
                    IERC20(tokenAddress).safeTransfer(msg.sender, rewardAmount);
                }
                userRewardAmounts[msg.sender][tokenAddress] = 0;
                tokenBalances[tokenAddress] -= rewardAmount;
            }
        }
    }


    function claimToken(address tokenAddress) external {
        require(tokenAddress != address(0), "Invalid token address");
        uint256 rewardAmount = userRewardAmounts[msg.sender][tokenAddress];
        require(rewardAmount > 0, "No reward available");
        if (tokenAddress == ethAddress) {
            (bool success, ) = msg.sender.call{value: rewardAmount}("");
            require(success, "ETH transfer failed");
        } else {
            IERC20(tokenAddress).safeTransfer(msg.sender, rewardAmount);
        }
        userRewardAmounts[msg.sender][tokenAddress] = 0;
        tokenBalances[tokenAddress] -= rewardAmount;
    }


    function withdrawETH(address payable withdrawAddress, uint256 amount) external payable onlyWithdrawManager returns (bool) {
        require(address(this).balance >= amount, "Insufficient ETH balance in contract");
        (bool success, ) = withdrawAddress.call{value: amount}("");
        if (!success) {
            return false;
        }
        tokenBalances[ethAddress] -= amount;
        emit WithdrawToken(
            ethAddress,
            msg.sender,
            withdrawAddress,
            amount
        );
        return true;
    }

    function withdrawERC20(IERC20 tokenAddress, address withdrawAddress, uint256 amount) external onlyWithdrawManager returns (bool) {
        require(tokenBalances[address(tokenAddress)] >= amount, "Insufficient token balance in contract");
        tokenAddress.safeTransfer(withdrawAddress, amount);
        tokenBalances[address(tokenAddress)] -= amount;
        emit WithdrawToken(
            address(tokenAddress),
            msg.sender,
            withdrawAddress,
            amount
        );
        return true;
    }

    function setTokenWhiteList(address tokenAddress) external onlyTreasureManager {
        if(tokenAddress == address(0)) {
            revert IsZeroAddress();
        }
        tokenWhiteList.push(tokenAddress);
    }

    function getTokenWhiteList() external view returns (address[] memory) {
        return tokenWhiteList;
    }

    function setWithdrawManager(address _withdrawManager) external onlyOwner {
        withdrawManager = _withdrawManager;
        emit WithdrawManagerUpdate(
            withdrawManager
        );
    }

    function queryReward(address _tokenAddress) public view returns (uint256) {
        return userRewardAmounts[msg.sender][_tokenAddress];
    }
}
```

**3.2.3.部署脚本**

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";


import {Script, console } from "forge-std/Script.sol";
import "../src/TreasureManager.sol";


contract TreasureManagerScript is Script {
    ProxyAdmin public dapplinkProxyAdmin;
    TreasureManager public treasureManager;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);


        vm.startBroadcast(deployerPrivateKey);

        dapplinkProxyAdmin = new ProxyAdmin(deployerAddress);
        console.log("PdapplinkProxyAdmin:", address(dapplinkProxyAdmin));

        treasureManager = new TreasureManager();

        TransparentUpgradeableProxy proxyTreasureManager = new TransparentUpgradeableProxy(
            address(treasureManager),
            address(dapplinkProxyAdmin),
            abi.encodeWithSelector(TreasureManager.initialize.selector, deployerAddress, deployerAddress, deployerAddress)
        );
        console.log("TransparentUpgradeableProxy deployed at:", address(proxyTreasureManager));

        vm.stopBroadcast();
    }
}
```

部署脚本执行命令

```sh
forge script script/TreasureManager.s.sol:TreasureManagerScript --rpc-url $RPC_URL --private-key $PRIVATE_
KEY --broadcast -vvvv
```

请将 RPC_URL 和 PRIVATE_KEY 环境变量配置成您自己的环境变量。

**3.2.4.升级脚本**

如果需要升级，改变逻辑合约之后，写升级脚本如下：

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import {Script, console } from "forge-std/Script.sol";
import "../src/TreasureManager.sol";


contract TreasureManagerV2 is Script {
    function run() public {
        address proxyAddmin = 0xa513E6E4b8f2a923D98304ec87F64353C4D5C853;
        address proxyTreasureManager = 0x8A791620dd6260079BF849Dc5567aDC3F2FdC318;

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);
        TreasureManager treasureManagerV2 = new TreasureManager();

        console.log("treasureManagerV2:", address(treasureManagerV2));

        ProxyAdmin(proxyAddmin).upgradeAndCall(ITransparentUpgradeableProxy(proxyTreasureManager), address(treasureManagerV2), bytes(""));

        vm.stopBroadcast();
    }
}
```

**脚本部署命令**

```sh
forge script script/TreasureManagerV2.s.sol:TreasureManagerV2 --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast -vvvv
```