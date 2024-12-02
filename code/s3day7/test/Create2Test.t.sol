// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/CreateTwoContract.sol";
import "../src/Create2Deployer.sol";
import "forge-std/Test.sol";

contract TestCreate2 is Test {
    function setUp() public {

    }
    function test_Deploy() public {
        vm.startBroadcast();
        console.log("===========startBroadcast=============");


        Create2Deployer deployer = new Create2Deployer();
        bytes32 salt = keccak256(abi.encodePacked("deploy-salt"));
        uint256 number = 123;

        address deployedAddress = deployer.deploy(salt, number);
        console.log("Deployed contract address:", deployedAddress);

        CreateTwoContract createTwoContract = CreateTwoContract(deployedAddress);
        console.log("Stored value:", createTwoContract.number());

        console.log("===========startBroadcast=============");

        vm.stopBroadcast();
    }

    function test_ComputeAddress() public {
        vm.startBroadcast();
        console.log("===========test_ComputeAddress=============");
        Create2Deployer deployer = new Create2Deployer();

        bytes32 salt = keccak256(abi.encodePacked("deploy-salt"));
        uint256 number = 123;
        address deployedAddress = deployer.computeAddress(salt, number);
        console.log("Deployed contract address:", deployedAddress);


        console.log("===========test_ComputeAddress=============");

        vm.stopBroadcast();
    }
}
