// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IL1PoolManager {
    function DepositAndStakingERC20(address _token, uint256 _amount) external;
    function DepositAndStakingETH() external payable;
}
