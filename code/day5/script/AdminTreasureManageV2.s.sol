// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import {Script, console } from "forge-std/Script.sol";
import "../src/TreasureManager.sol";


contract TreasureManagerV2 is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);
        TreasureManager treasureManagerV2 = new TreasureManager();

        console.log("treasureManagerV2:", address(treasureManagerV2));

        ITransparentUpgradeableProxy(address(0x8A791620dd6260079BF849Dc5567aDC3F2FdC318)).upgradeToAndCall(treasureManagerV2);

        vm.stopBroadcast();
    }
}
