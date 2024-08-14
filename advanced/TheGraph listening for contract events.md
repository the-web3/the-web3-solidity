# TheGraph 监听合约事件细节解读与代码实战

# 1.什么是Graph

Graph 是一个去中心化的协议，用于索引和查询区块链的数据。 它使查询那些难以直接查询的数据成为可能。它的主要作用包括：

- **数据索引和查询**：The Graph 提供了一种高效的方式来索引和查询区块链上的数据。通过 Subgraph，开发者可以定义他们想要索引的数据以及如何查询这些数据。
- **简化 DApp 开发**：开发者可以通过 The Graph 快速获取他们应用所需的数据，而不需要自己编写复杂的后端代码来从区块链节点获取和处理数据。这简化了去中心化应用（DApp）的开发过程。
- **提高查询速度**：直接从区块链节点查询数据可能会非常慢，因为区块链数据通常是未索引的且分布在多个节点上。The Graph 通过预先索引数据，显著提高了查询速度，使得实时应用成为可能。
- **支持多种区块链网络**：虽然 The Graph 最初是为以太坊设计的，但它现在支持多个区块链网络，包括 IPFS、Polkadot 和 NEAR 等，使得它成为跨链应用的一个有力工具。
- **去中心化和社区驱动**：The Graph 是一个去中心化的协议，由社区运行的节点（Indexers）来处理索引和查询请求。这使得它具有高可用性和抗审查性。
- **GraphQL 查询语言**：The Graph 使用 GraphQL 作为查询语言。GraphQL 提供了强大的查询能力，使得开发者可以轻松地获取他们所需的精确数据，而不会有多余的数据传输。

# 2.Graph 的工作流程

![图像](../picture/grapg1.jpg)

流程遵循这些步骤：

- 一个去中心化的应用程序通过智能合约上的交易向以太坊添加数据。
- 智能合约在处理交易时，会发出一个或多个事件。
- Graph 节点不断扫描以太坊的新区块和它们可能包含的子图的数据。
- Graph 节点在这些区块中为你的子图找到以太坊事件并运行你提供的映射处理程序。 映射是一个 WASM 模块，它创建或更新 Graph 节点存储的数据实体，以响应以太坊事件。
- 去中心化的应用程序使用Graph节点的 GraphQL 端点，从区块链的索引中查询 Graph 节点的数据。 Graph 节点反过来将 GraphQL 查询转化为对其底层数据存储的查询，以便利用存储的索引功能来获取这些数据。 去中心化的应用程序在一个丰富的用户界面中为终端用户显示这些数据，他们用这些数据在以太坊上发行新的交易。 就这样周而复始。

# 3.Graph 网络组成和 The Graph Studio

Graph 网络由索引人、策展人和委托人组成，为网络提供服务，并为 Web3 应用程序提供数据。 消费者使用应用程序并消费数据。

![图像](../picture/grapg2.jpg)

## 3.1.索引人 (Indexers)

**作用**:

- **运行节点**：索引人在 The Graph 网络中运行全节点，处理和存储来自区块链的数据。
- **创建和维护索引**：索引人负责创建和维护 Subgraph 的索引，以便快速处理查询请求。
- **处理查询**：他们接收并处理来自去中心化应用（DApps）的 GraphQL 查询请求。
- **赚取奖励**：通过处理查询和维护索引，索引人可以赚取查询费用和通胀奖励。

**要求**:

- **技术能力**：需要有运行和维护节点的技术知识。
- **GRT 抵押**：索引人需要抵押一定数量的 GRT 代币，以确保他们的行为诚实并激励他们提供高质量的服务。

## 3.2.策展人 (Curators)

**作用**:

- **信号 Subgraphs**：策展人使用 GRT 代币对高质量的 Subgraphs 进行信号，以表示这些 Subgraphs 包含有价值的数据。
- **帮助索引人**：通过对 Subgraphs 进行信号，策展人帮助索引人确定哪些数据应该被索引，从而提高索引效率和数据质量。
- **赚取奖励**：策展人可以通过他们的信号获得查询费用的一部分作为奖励。

**要求**:

- **知识和判断力**：需要对区块链数据和去中心化应用有深入了解，以识别和信号高质量的 Subgraphs。
- **GRT 投资**：策展人需要投资 GRT 代币用于信号。

## 3.3.委托人 (Delegators)

**作用**:

- **支持索引人**：委托人将他们的 GRT 代币委托给索引人，以帮助索引人增加抵押和提高服务能力。
- **赚取奖励**：通过委托 GRT 代币，委托人可以获得索引人赚取的查询费用和通胀奖励的一部分。

**要求**:

- **选择索引人**：需要了解和评估不同的索引人，以选择那些他们认为最有能力和信誉的索引人。
- **GRT 代币**：需要拥有 GRT 代币并将其委托给索引人。

## 3.4.The Graph Studio

The Graph Studio 是一个用于构建、部署和管理子图（Subgraph）的用户界面工具。它为开发者提供了一种简化的方式来与 The Graph 协议进行交互，特别是在构建基于区块链的应用时。

3.4.1.**创建子图**：

- 允许开发者通过图形化界面创建子图。你可以定义你想要索引的智能合约和事件，以及如何将这些数据映射到实体（Entities）中。

3.4.2.**部署子图**：

- 在完成子图的开发后，可以将其部署到 The Graph Network 上的主网或测试网（如 Rinkeby 或 Goerli）。
- 部署子图后，它会开始从区块链上索引数据，并允许你通过 GraphQL API 查询这些数据。

3.4.3.**管理子图**：

- The Graph Studio 提供了一个仪表板，允许你查看子图的状态、索引进度和性能。
- 你还可以在子图发生错误时，查看日志并进行调试。

3.4.4.**测试和调试**：

- 在部署到主网之前，可以在 The Graph Studio 中测试你的子图，确保它正确索引和处理数据。
- Studio 提供了一个交互式的 GraphQL Playground，让你可以直接在浏览器中运行查询并检查响应。

3.4.5.**更新和迁移**：

- 如果你需要对子图进行更新（例如修改映射逻辑或添加新的数据源），可以在 The Graph Studio 中进行更新和重新部署。
- The Graph Studio 支持子图的版本控制和迁移功能，使得管理不同版本的子图变得容易。

**3.4.6. Studio 部署使用过程**

- 打开 https://thegraph.com/studio/， 创建一个子图
- 安装 Graph cli

```sh
npm install -g @graphprotocol/graph-cli
或者
yarn global add @graphprotocol/graph-cli
```

- 交互式命令行输入网络，合约等信息

```sh
graph init --studio dapplink-treasure
```

- 认证和部署

```sh
graph auth --studio 903b14f15185df1f843fb76f33bed1ab
cd dapplink-treasure
graph codegen && graph build
graph deploy --studio dapplink-treasure
```

# 4.subgraph 编码实战

## 4.1.启动本地 Graphnode 和 IPFS 网络

- docker-compose.yml

```yaml
version: '3'
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_USER: postgres
      POSTGRES_DB: graph-node
      POSTGRES_HOST_AUTH_METHOD: trust
    ports:
      - '5432:5432'
    volumes:
      - pgdata:/var/lib/postgresql/data

  ipfs:
    image: ipfs/go-ipfs:v0.4.23
    ports:
      - '5001:5001'
      - '8080:8080'
      - '4001:4001'
    volumes:
      - ipfsdata:/data/ipfs

  graph-node:
    image: graphprotocol/graph-node:latest
    ports:
      - '8000:8000'
      - '8020:8020'
      - '8030:8030'
      - '8040:8040'
      - '8001:8001'
    depends_on:
      - postgres
      - ipfs
    environment:
      postgres_host: postgres
      postgres_user: postgres
      postgres_pass: ''
      postgres_db: graph-node
      ipfs: 'ipfs:5001'
      ethereum: 'mainnet:https://eth-holesky.g.alchemy.com/v2/BvSZ5ZfdIwB-5SDXMz8PfGcbICYQqwrl'
    volumes:
      - ./data:/data

volumes:
  pgdata:
  ipfsdata:
```

- 启动命令：docker-compose up -d
- 查看日志：docker-compose logs -f

## 4.2. 本地编写 dapplink treasure 合约事件监听器

**4.2.1.合约 ABI 准备**

- dapplink treasure 合约代码仓库：https://github.com/eniac-x-labs/dapplink-treasure
- 克隆 dapplink treasure 代码

```sh
git clone git@github.com:eniac-x-labs/dapplink-treasure.git
```

- 编译 dapplink treasure 代码

```sh
cd dapplink-treasure
forge compile
```

- 编译完成之后，你可以在代码目录里面看到一个 out 目录，从中提取 ABI 文件

![图像](../picture/grapg3.jpg)

- ABI 文件为：/TreasureManager.sol/TreasureManager.json

**4.2.2. 本地编写和部署 subgraph 项目**

初始化项目

```sh
mkdir subgraph
cd subgraph
npm init
```

编写 package.json

```json
{
  "name": "subgraph",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "codegen": "graph codegen",
    "build": "graph build",
    "depoy": "graph deploy --node https://api.studio.thegraph.com/deploy/ dapplinksubgraph",
    "create-local": "graph create --node http://127.0.0.1:8020/ dapplinksubgraph",
    "remove-local": "graph remove --node http://127.0.0.1:8020/ dapplinksubgraph",
    "deploy-local": "graph deploy --node http://127.0.0.1:8020/ --ipfs http://127.0.0.1:5001 dapplinksubgraph",
    "meda": "yarn remove-local && yarn create-local && yarn deploy-local",
    "test": "graph test"
  },
  "author": "",
  "license": "ISC",
  "dependencies": {
    "@graphprotocol/graph-cli": "^0.80.0",
    "@graphprotocol/graph-ts": "^0.35.1"
  }
}
```

- depoy: 将 subgraph 部署到 The Graph 的 studio 上
- meda：集成了本地删除，创建和部署命令, 需要注意本地的 graph-node 和 ipfs 监听的端口，不要写错了

建立 abis 目录，将 abi 文件拷贝到该目录下

![图像](../picture/grapg4.png)

编写 subgraph.yaml，我们可以看到 TreasureManager 合约里面有以下事件

```solidity
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
```

故而我们编写的 subgraph.yaml 如下， 重要的代码解释请看文件

```yaml
dataSources:
- kind: ethereum
  mapping:
    abis:
    - file: ./abis/TreasureManager.json   # ABI 所在的文件目录
      name: TreasureManager               # 合约名字
    apiVersion: 0.0.7
    entities:    # 监听的事件 entities，按照下面的格式是事件就行
    - DepositToken
    - WithdrawToken
    - GrantRewardTokenAmount
    - WithdrawManagerUpdate
    eventHandlers: #事件处理器
    - event: DepositToken(indexed address,indexed address,uint256) #合约事件
      handler: handleDepositToken #合约事件触发调用函数
      receipt: true
    - event: WithdrawToken(indexed address,address,address,uint256)
      handler: handleWithdrawToken
      receipt: true
    - event: GrantRewardTokenAmount(indexed address,address,uint256)
      handler: handleGrantRewardTokenAmount
      receipt: true
    - event: WithdrawManagerUpdate(indexed address)
      handler: handleWithdrawManagerUpdate
      receipt: true
    file: ./src/dapplink-treasure.ts # 合约事件触发调用函数代码文件所在目录
    kind: ethereum/events
    language: wasm/assemblyscript
  name: TreasureManager
  network: mainnet # 网络配置，这里的网络配置一定要和 graphnode 里面的配置一致，否则同步不了事件
  source:
    abi: TreasureManager     # ABI 名字
    address: '0x0B306BF915C4d645ff596e518fAf3F9669b97016' # 合约地址
    startBlock: 0  # 监听的开始块高
schema:
  file: ./schema.graphql  # graphql schema 定义文件，graphql 查询定义
specVersion: 0.0.5
```

graphql schema 定义

```js
type DepositToken @entity {
    id: ID!
    tokenAddress: Bytes!
    sender: Bytes!
    amount: BigInt!
}

type WithdrawToken @entity {
    id: ID!
    tokenAddress: Bytes!
    sender: Bytes!
    withdrawAddress: Bytes!
    amount: BigInt!
}

type GrantRewardTokenAmount @entity {
    id: ID!
    tokenAddress: Bytes!
    granter: Bytes!
    amount: BigInt!
}

type WithdrawManagerUpdate @entity {
    id: ID!
    withdrawManager: Bytes!
}
```

执行 yarn codegen 生成 TreasureManager 和 schema 代码

![图像](../picture/grapg5.png)

- TreasureManager 和 schema 生成的代码文件

编写 dapplink-treasure.ts 的代码，接收合约事件按照业务处理数据存储

```js
import { BigInt, Address, ethereum, Bytes, ByteArray } from "@graphprotocol/graph-ts";
import { DepositETHCall } from '../generated/TreasureManager/TreasureManager'
import { DepositToken, WithdrawToken, GrantRewardTokenAmount,WithdrawManagerUpdate } from '../generated/schema'
import { crypto , log } from '@graphprotocol/graph-ts'

export function handleDepositToken(event: DepositToken): void {
    log.debug('handleInitDataStore', [])
    let eventId = event.id;
    let depositToken = new DepositToken(eventId);
    depositToken.tokenAddress = event.tokenAddress;
    depositToken.sender = event.sender;
    depositToken.amount = event.amount;
    depositToken.save()
}

export function handleWithdrawToken(event: WithdrawToken): void {
    log.debug('handleWithdrawToken', [])
    let eventId = event.id;
    let withdrawToken = new WithdrawToken(eventId);
    withdrawToken.tokenAddress = event.tokenAddress;
    withdrawToken.withdrawAddress = event.withdrawAddress;
    withdrawToken.amount = event.amount;
    withdrawToken.save()
}

export function handleGrantRewardTokenAmount(event: GrantRewardTokenAmount): void {
    log.debug('handleGrantRewardTokenAmount', [])
    let grantRewardsEvent = new GrantRewardTokenAmount(event.id)
    grantRewardsEvent.amount = event.amount;
    grantRewardsEvent.tokenAddress = event.tokenAddress;
    grantRewardsEvent.granter = event.granter;
    grantRewardsEvent.save();
}

export function handleWithdrawManagerUpdate(event: WithdrawManagerUpdate): void {
    log.debug('handleWithdrawManagerUpdate', [])
    let withdrawManagerUpdate = new WithdrawManagerUpdate(event.id)
    withdrawManagerUpdate.withdrawManager = withdrawManagerUpdate.withdrawManager
    withdrawManagerUpdate.save();
}
```

- 这里的处理都是将几个合约事件存储起来，通过 graphql 查询对应的事件

4.2.3.构建部署

- 构建

```sh
yarn build
```

- 部署

```sh
yarn meda
```

- 部署到 TheGraph studio

```sh
yarn depoly
```

部署完成之后触发合约事件就可以监听到，通过 graphql 接口就可以查询到事件了

The web3 subgraph 完整代码链接：https://github.com/the-web3/subgraph

# 5.subgraph 在实际项目的使用案例

https://thegraph.com/explorer

在 The Graph 的浏览器中可以看到很多 Defi 都使用 subgraph 索引合约事件，除此之外，有的知名项目也使用了 subgraph, 例如 MantleDa 中使用了 subgraph 监听 da 节点的注册推出，交易数据提交确认等事件。