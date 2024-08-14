# Solidity 智能合约 UUPS 代理升级实战

代理升级模式包括不同的实现方式，主要有透明代理、UUPS 代理和 Beacon 代理。本文主要讲解 UUPS 代理的特点和代码实战。

# 一.UUPS 代理升级介绍

UUPS 代理是 EIP-1822 提出的标准，它改进了传统的透明代理模式，减少了代理合约的复杂性和 gas 消耗。UUPS 代理合约只包含代理逻辑和升级逻辑，且升级合约的权限控制嵌入到逻辑合约中； UUPS 代理升级的特点如下：

- UUPS 代理模式允许升级逻辑在逻辑合约中控制，减少了代理合约的复杂度。
- 代理合约不再包含业务逻辑，减少了 gas 成本。
- 逻辑合约中需要实现 _authorizeUpgrade 方法来控制升级权限。

# 二. UUPS 代理升级实战

下面我们写两个简单的合约：UUPSContractV1 和 UUPSContractV2，UUPSContractV1 合约里面写一个简单的 setValue 函数，UUPSContractV2 升级之后加入两个函数，分别是  incrementValue 和 upgradeCall。

## 1.合约代码细节

- UUPSContractV1 合约代码如下

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


contract UUPSContractV1 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 public value;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
        value = 10000;
    }

    function setValue(uint256 _value) public  {
        value = _value;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
```

- UUPSContractV2 合约代码如下

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @custom:oz-upgrades-from UUPSContractV1
contract UUPSContractV2 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 public value;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor(){
    }

    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
        value = 10;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function setValue(uint256 _value) public onlyOwner {
        value = _value;
    }

    function incrementValue() public onlyOwner {
        value += 1;
    }

    function upgradeCall() public onlyOwner {
        value = 100;
    }
}
```

UUPSContractV2 里面我们写了 

```text
/// @custom:oz-upgrades-from UUPSContractV1
```

这个是必要的，因为我们升级脚本里面使用了 @openzeppelin-foundry-upgrades/Upgrades.sol 这个代码库，如果不加这段代码，升级部署的时候会报错。

## **2.部署脚本细节**

- 部署 UUPSContractV1 的脚本 DeployUUPSProxyScript

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "forge-std/Script.sol";
import "../src/UUPSContractV1.sol";


contract DeployUUPSProxyScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);

        console.log("Deploying contracts with the account:", deployerAddress);
        vm.startBroadcast(deployerPrivateKey);

        UUPSContractV1 implementation = new UUPSContractV1();

        console.log("UUPSContractV1 address:", address(implementation));

        bytes memory data = abi.encodeCall(implementation.initialize, deployerAddress);

        ERC1967Proxy proxy = new ERC1967Proxy(address(implementation), data);

        vm.stopBroadcast();

        console.log("UUPS Proxy Address:", address(proxy));
    }
}
```

执行该命令进行部署 V1 的合约

```sh
forge script script/DeployUUPSProxy.sol:DeployUUPSProxyScript --rpc-url http://127.0.0.1:8545 --private-key $PRIVATE_KEY --broadcast -vvvv
```

- 将 UUPSContractV1 升级到 V2 的升级脚本

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import { Upgrades } from "@openzeppelin-foundry-upgrades/Upgrades.sol";

import "../src/UUPSContractV2.sol";


contract UUPSContractV2Script is Script {
    address public proxy = 0xEd63674ebAEd5D5fe567b41Bab2ac16e2f9c1386;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);

        console.log("Deploying Address:", deployerAddress);

        vm.startBroadcast(deployerPrivateKey);

        Upgrades.upgradeProxy(address(proxy), "UUPSContractV2.sol:UUPSContractV2", "", deployerAddress);

        (bool successful,) = address(proxy).call(abi.encodeWithSelector(UUPSContractV2.incrementValue.selector));

        console.log("incrementValue success:", successful);

        vm.stopBroadcast();
    }
}
```

执行下面部署命令升级合约

```sh
forge script script/UUPSContractV2.s.sol:UUPSContractV2Script --rpc-url http://127.0.0.1 --private-key $PRIVATE_KEY  --broadcast -vvvv
```

执行这个命令如果遇到让您 clean 合约的错误，可以执行 forge clean & forge build 之后再执行上面的部署命令可以解决问题。

以上就是 UUPS 代理合约升级的实战过程，如果您想深入学习 Web3 技术，可以联系 The Web 社区，我们提供一站式的区块链技术培训服务。

# 三. The Web3 社区简介

The Web3 是一个专注 Web3 技术解决方案设计与开发、技术教程设计与开发、Web3 项目投研分析和 Web3 项目孵化，旨在将开发者，创业者，投资者和项目方联系在一起的社区。

## The web3 业务范围

- 技术服务：提供交易所钱包，HD 钱包，硬件钱包，MPC 托管钱包，Dapps,  质押协议，L1，L2 ，L3 公链，数据可用层（DA）和中心化交易所技术开发服务。
- 技术培训：提供个人技术成长和企业技术培训服务
- 开发者活动承接：各种线下线上黑客松和开发者 meetup 活动承接
- 除此之外，我们还和 "磐石安全实验室" 深入合作，开展去中心化安全审计服务

# 四.The Web3 社区官方链接

- github: https://github.com/the-web3
- X: https://twitter.com/0xtheweb3cn
- telegram: https://t.me/+pmoh3D4uTAFjNWM1
- discord: https://discord.gg/muhuXRsK
- the web3 官网：https://thewebthree.xyz/
- the web3 技术服务网站：https://web.thewebthree.xyz/