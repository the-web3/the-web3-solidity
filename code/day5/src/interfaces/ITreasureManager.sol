// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ITreasureManager {
    function depositETH() external payable returns (bool);
    function depositERC20(IERC20 tokenAddress, uint256 amount) external returns (bool);
    function grantRewards(address tokenAddress, address granter, uint256 amount) external;
    function claimAllTokens() external;
    function claimToken(address tokenAddress) external;
    function withdrawETH(address payable withdrawAddress, uint256 amount) external payable returns (bool);
    function withdrawERC20(IERC20 tokenAddress, address withdrawAddress, uint256 amount) external returns (bool);
    function setTokenWhiteList(address tokenAddress) external;
    function setWithdrawManager(address _withdrawManager) external;
    function queryReward(address _tokenAddress) external view returns (uint256);
    function getTokenWhiteList() external view returns (address[] memory);
}
