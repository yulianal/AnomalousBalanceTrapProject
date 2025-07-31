// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrap {
    function collect() external view returns (bytes memory);
    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory);
}

contract AnomalousBalanceTrap is ITrap {
    address public constant target = 0x6493490386f9F78205B284B99A2E6126C4167498;
    uint256 public constant thresholdPercent = 20;
    uint256 public constant minDiffWei = 5 ether;

    function collect() external view override returns (bytes memory) {
        return abi.encode(target.balance);
    }

    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        if (data.length < 2) return (false, abi.encode("Not enough data"));

        uint256 latest = abi.decode(data[0], (uint256));
        uint256 previous = abi.decode(data[1], (uint256));

        if (previous == 0) return (false, abi.encode("First run"));

        if (latest > previous) {
            uint256 diff = latest - previous;
            uint256 percent = (diff * 100) / previous;

            if (diff >= minDiffWei && percent >= thresholdPercent) {
                return (true, abi.encode(diff, percent));
            }
        }

        return (false, "");
    }
}
