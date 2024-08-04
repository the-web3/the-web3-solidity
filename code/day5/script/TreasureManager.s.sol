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
