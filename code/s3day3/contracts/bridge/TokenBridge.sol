// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


abstract contract TokenBridge {
    /*
     * require: 用于检查输入条件或者和状态变量，全局变量等是否一致，如果条件不满足抛出异常并返回到初始状态
     * assert: 用于检查条件是否满足预期，一般测试用例里面用得比较多，
     * revert: 开发者可以显示定义错误(携带错误信息)，当发生这个错误时候抛出这个错误，从 0.8.4 之后支持;
     * 三者失败都是消耗执行之前的 gas， 比较特殊一点的是 assert 之后的 gas 也消耗
   */
    using SafeERC20 for IERC20;

    address public constant ETHAddress = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

    uint256 public MinTransferAmount;
    uint256 public FundingPoolBalance;

    event InitiateETH(
        address indexed from,
        address indexed to,
        uint256 sourceChainId,
        uint256 destChainId,
        uint256 value
    );

    event InitiateERC20(
        address indexed from,
        address indexed to,
        address indexed ERC20Address,
        uint256 sourceChainId,
        uint256 destChainId,
        uint256 value
    );

    event FinalizeETH(
        uint256 sourceChainId,
        uint256 destChainId,
        address indexed from,
        address indexed to,
        uint256 value
    );


    event FinalizeERC20(
        uint256 sourceChainId,
        uint256 destChainId,
        address indexed ERC20Address,
        address indexed from,
        address indexed to,
        uint256 value
    );


    error sourceChainIdError();
    error MinTransferAmountErr();

    function BridgeInitETH(uint256 sourceChainId, uint256 destChainId, address to)  external payable returns (bool) {
        require(sourceChainId == block.chainId, "source chain is not equal dest chain id");

        if (sourceChainId != block.chainId) {
            revert sourceChainIdError();
        }

        if(msg.value < MinTransferAmount) {
            revert MinTransferAmountErr();
        }

        FundingPoolBalance[ETHAddress] += msg.value;

        uint256 fee = (msg.value * 5) / 1000;

        uint transferAmount =  msg.value - fee;

        emit InitiateETH(msg.sender, to, sourceChainId, destChainId, transferAmount);

        return true;
    }


    function BridgeInitERC20(uint256 sourceChainId, uint256 destChainId, address to, address Erc20Address, uint256 value)  external payable returns (bool) {
        require(sourceChainId == block.chainId, "source chain is not equal dest chain id");

        if (sourceChainId != block.chainId) {
            revert sourceChainIdError();
        }

        if(msg.value < MinTransferAmount) {
            revert MinTransferAmountErr();
        }

        uint256 BalanceBefore = IERC20(ERC20Address).balanceOf(address(this));
        IERC20(ERC20Address).safeTransferFrom(msg.sender, address(this), value);
        uint256 BalanceAfter = IERC20(ERC20Address).balanceOf(address(this));
        uint256 amount = BalanceAfter - BalanceBefore;
        FundingPoolBalance[ERC20Address] += value;
        uint256 fee = (amount * 5) / 1_000_000;
        amount -= fee;
        FeePoolValue[ERC20Address] += fee;

        emit InitiateERC20(
            msg.sender,
            to,
            ERC20Address,
            sourceChainId,
            destChainId,
            amount
        );

        return true;
    }


    function BridgeFinalizeETH(
        uint256 sourceChainId,
        uint256 destChainId,
        address to,
        uint256 amount,
        uint256 _fee,
        uint256 _nonce
    ) external payable onlyRole(ReLayer) returns (bool) {
        if (destChainId != block.chainid) {
            revert sourceChainIdError();
        }
        if (!IsSupportChainId(sourceChainId)) {
            revert ChainIdIsNotSupported(sourceChainId);
        }
        (bool _ret, ) = payable(to).call{value: amount}("");
        if (!_ret) {
            revert TransferETHFailed();
        }
        FundingPoolBalance[ContractsAddress.ETHAddress] -= amount;

        emit FinalizeETH(sourceChainId, destChainId, address(this), to, amount);
        return true;
    }

    function BridgeFinalizeERC20(
        uint256 sourceChainId,
        uint256 destChainId,
        address to,
        address ERC20Address,
        uint256 amount,
        uint256 _fee,
        uint256 _nonce
    ) external onlyRole(ReLayer) returns (bool) {
        if (destChainId != block.chainid) {
            revert sourceChainIdError();
        }
        if (!IsSupportChainId(sourceChainId)) {
            revert ChainIdIsNotSupported(sourceChainId);
        }
        if (!IsSupportToken[ERC20Address]) {
            revert TokenIsNotSupported(ERC20Address);
        }
        IERC20(ERC20Address).safeTransfer(to, amount);
        FundingPoolBalance[ERC20Address] -= amount;

        emit FinalizeERC20(
            sourceChainId,
            destChainId,
            ERC20Address,
            address(this),
            to,
            amount
        );

        return true;
    }


}
