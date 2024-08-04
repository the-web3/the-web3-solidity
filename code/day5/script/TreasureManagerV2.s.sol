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
