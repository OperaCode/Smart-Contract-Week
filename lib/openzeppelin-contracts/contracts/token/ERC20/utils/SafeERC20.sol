// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IERC20.sol";
import "../../../utils/Address.sol";

library SafeERC20 {
    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        bytes memory returndata = Address.functionCall(address(token), data);
        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), "SafeERC20: operation did not succeed");
        }
    }
}
