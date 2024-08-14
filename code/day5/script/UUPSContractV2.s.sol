// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import { Upgrades } from "@openzeppelin-foundry-upgrades/Upgrades.sol";

import "../src/UUPSContractV2.sol";


/*
forge script script/UUPSContractV2.s.sol:UUPSContractV2Script --rpc-url http://127.0.0.1 --private-key ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80  --broadcast -vvvv
*/
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
