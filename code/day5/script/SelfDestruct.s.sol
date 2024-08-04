// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";


import {Script, console} from "forge-std/Script.sol";
import "../src/SelfDestruct.sol";


/*
forge script script/SelfDestruct.s.sol:SelfDestructScript --rpc-url https://eth-holesky.g.alchemy.com/v2/BvSZ5ZfdIwB-5SDXMz8PfGcbICYQqwrl --private-key f18b433b7f3d67a7458b612852b1ec1b10930b532546e9a7852425969d92ed2b  --broadcast -vvvv
*/
contract SelfDestructScript is Script {
    ProxyAdmin public theweb3ProxyAddmin;
    SelfDestruct public selfDestuct;


    function run() public {
        uint256 depolyerPrivateKey = vm.envUint("PRIVATE_KEY");
        address depolyerAddress = vm.addr(depolyerPrivateKey);

        vm.startBroadcast(depolyerPrivateKey);

        theweb3ProxyAddmin = ProxyAdmin(depolyerAddress);

        console.log("theweb3ProxyAddmin depoly at:", address(theweb3ProxyAddmin));

        selfDestuct = new SelfDestruct();

        TransparentUpgradeableProxy proxySelfDestuct = new TransparentUpgradeableProxy(
            address(selfDestuct),
            address(theweb3ProxyAddmin),
            abi.encodeWithSelector(SelfDestruct.initialize.selector, depolyerAddress, depolyerAddress)
        );

        console.log("proxySelfDestuct depoly at:", address(proxySelfDestuct));

        vm.stopBroadcast();
    }
}
