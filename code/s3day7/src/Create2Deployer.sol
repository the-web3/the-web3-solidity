// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./CreateTwoContract.sol";

contract Create2Deployer {
    function deploy(bytes32 salt, uint256 number) external returns (address) {
        address addr;
        bytes memory bytecode = type(CreateTwoContract).creationCode;
        bytes memory payload = abi.encodePacked(bytecode, abi.encode(number));
        assembly {
            addr := create2(0, add(payload, 0x20), mload(payload), salt)
            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }
        }
        return addr;
    }

    function computeAddress(bytes32 salt, uint256 number) external view returns (address) {
        bytes memory bytecode = type(CreateTwoContract).creationCode;
        bytes memory payload = abi.encodePacked(bytecode, abi.encode(number));
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff), address(this), salt, keccak256(payload)));
        return address(uint160(uint256(hash)));
    }
}
