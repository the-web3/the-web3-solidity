// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Create2Deployer} from "../src/Create2Deployer.sol";
import {CreateTwoContract} from "../src/CreateTwoContract.sol";

/*
 * 实际部署合约时候，如何保证合约地址一致性
 * - Create: sender(deployer) 和 nonce 相关，只要保证 deployer 和 nonce 一致，在任意 EVM 部署出来合约地址都是一样
 *  create contract address = keccake256(deployer, nonce)[12:]
*/
// 46f0a3aadd91062d467d27c980f6a6d6d5dc54a18c38c62b1104f3a28daab44b
// 0xE2794a77096E58297aed14EeC434A72eCd6353A8
// forge script ./script/Create2Script.s.sol:Create2Script --rpc-url  https://eth-holesky.g.alchemy.com/v2/xis9zzUnd3ts5uZmF9BipBpeWfcYBNzb --private-key $PRIVATEKEY  --broadcast --vvvv

// Ceate2
// - 0xFF
// - deployer
// - salt
// - bytecode
// address = keccake256(0xff, deployer, salt, bytecode)
// 应用场景
// - 质押 createPod:
// - 钻石代理
// - uniswap: create pair: create2

contract Create2Script is Script {
    Create2Deployer public create2Deployer;

    function setUp() public {
    }

    function run() public {
        vm.startBroadcast();
        create2Deployer = new Create2Deployer();

        Create2Deployer deployer = new Create2Deployer();
        bytes32 salt = keccak256(abi.encodePacked("deploy-salt"));
        uint256 number = 123;

        address deployedAddress = deployer.deploy(salt, number);
        console.log("Deployed contract address:", deployedAddress);

        CreateTwoContract createTwoContract = CreateTwoContract(deployedAddress);
        console.log("Stored value:", createTwoContract.number());

        vm.stopBroadcast();
    }
}
