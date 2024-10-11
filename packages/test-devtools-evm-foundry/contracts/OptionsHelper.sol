// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import { ExecutorOptions } from "@layerzerolabs/lz-evm-protocol-v2/contracts/messagelib/libs/ExecutorOptions.sol";
import { UlnOptions } from "@layerzerolabs/lz-evm-messagelib-v2/contracts/uln/libs/UlnOptions.sol";

contract UlnOptionsMock {
    using UlnOptions for bytes;

    function decode(
        bytes calldata _options
    ) public pure returns (bytes memory executorOptions, bytes memory dvnOptions) {
        return UlnOptions.decode(_options);
    }
}

contract OptionsHelper {
    /// @dev For backwards compatibility reasons, we'll keep this initialization here
    /// @dev Any new tests should use the _setUpUlnOptions function below
    UlnOptionsMock ulnOptions = new UlnOptionsMock();

    function _setUpUlnOptions() internal {
        ulnOptions = new UlnOptionsMock();
    }

    function _parseExecutorLzReceiveOption(bytes memory _options) internal view returns (uint256 gas, uint256 value) {
        (bool exist, bytes memory option) = _getExecutorOptionByOptionType(
            _options,
            ExecutorOptions.OPTION_TYPE_LZRECEIVE
        );
        require(exist, "OptionsHelper: lzReceive option not found");
        (gas, value) = this.decodeLzReceiveOption(option);
    }

    function _parseExecutorNativeDropOption(
        bytes memory _options
    ) internal view returns (uint256 amount, bytes32 receiver) {
        (bool exist, bytes memory option) = _getExecutorOptionByOptionType(
            _options,
            ExecutorOptions.OPTION_TYPE_NATIVE_DROP
        );
        require(exist, "OptionsHelper: nativeDrop option not found");
        (amount, receiver) = this.decodeNativeDropOption(option);
    }

    function _parseExecutorLzComposeOption(
        bytes memory _options
    ) internal view returns (uint16 index, uint256 gas, uint256 value) {
        (bool exist, bytes memory option) = _getExecutorOptionByOptionType(
            _options,
            ExecutorOptions.OPTION_TYPE_LZCOMPOSE
        );
        require(exist, "OptionsHelper: lzCompose option not found");
        return this.decodeLzComposeOption(option);
    }

    function _executorOptionExists(
        bytes memory _options,
        uint8 _executorOptionType
    ) internal view returns (bool exist) {
        (exist, ) = _getExecutorOptionByOptionType(_options, _executorOptionType);
    }

    function _getExecutorOptionByOptionType(
        bytes memory _options,
        uint8 _executorOptionType
    ) internal view returns (bool exist, bytes memory option) {
        (bytes memory executorOpts, ) = ulnOptions.decode(_options);

        // uint128 - 128 bits = 16 bytes = 0x10
        uint256 U128_LENGTH = 0x10;
        uint256 cursor;

        uint128 lz_gas;
        uint128 lz_value;

        while (cursor < executorOpts.length) {
            (uint8 optionType, bytes memory op, uint256 nextCursor) = this.nextExecutorOption(executorOpts, cursor);

            uint128 newGas;
            uint128 newValue;

            // author: Shankar - Integrations team
            if (optionType == _executorOptionType) {
                assembly {
                    // Grab the gas value from the first 16 bytes
                    let _gas := mload(add(op, U128_LENGTH))

                    // Grab the value from the next 16 bytes (if there is none this is just 0)
                    let _value := mload(add(op, mul(U128_LENGTH, 2)))

                    newGas := add(lz_gas, _gas)

                    // To improve readability I am not using lz_value := add(lz_value, _value) directly
                    newValue := add(lz_value, _value)
                }

                // The value can not overflow as there is a max limit specified which is 0.1 ether
                // The gas can overflow and so we have a check for that
                if (newGas < lz_gas) {
                    revert("OptionsHelper: gas overflow");
                }

                lz_gas = newGas;
                lz_value = newValue;
            }

            cursor = nextCursor;
        }

        bytes memory payload = abi.encodePacked(lz_gas, lz_value);
        return (true, payload);
    }

    function nextExecutorOption(
        bytes calldata _options,
        uint256 _cursor
    ) external pure returns (uint8 optionType, bytes calldata option, uint256 cursor) {
        return ExecutorOptions.nextExecutorOption(_options, _cursor);
    }

    function decodeLzReceiveOption(bytes calldata _option) external pure returns (uint128 gas, uint128 value) {
        return ExecutorOptions.decodeLzReceiveOption(_option);
    }

    function decodeNativeDropOption(bytes calldata _option) external pure returns (uint128 amount, bytes32 receiver) {
        return ExecutorOptions.decodeNativeDropOption(_option);
    }

    function decodeLzComposeOption(
        bytes calldata _option
    ) external pure returns (uint16 index, uint128 gas, uint128 value) {
        return ExecutorOptions.decodeLzComposeOption(_option);
    }
}
