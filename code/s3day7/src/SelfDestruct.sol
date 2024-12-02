// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SelfDestruct is Initializable, AccessControlUpgradeable, ReentrancyGuardUpgradeable, OwnableUpgradeable {
    address payable public destructer;
    uint256 public data;

    receive() external payable {}

    modifier onlyDestructer() {
        require(msg.sender == destructer, "Only destructer can call this function");
        _;
    }

    function setData(uint256 _data) external {
        data = _data;
    }

    function initialize(address _initialOwner, address _destructer) public initializer {
        _transferOwnership(_initialOwner);
        destructer = payable(_destructer);
        data = 1000;
    }

    function close() public onlyDestructer {
        selfdestruct(destructer);
    }
}
