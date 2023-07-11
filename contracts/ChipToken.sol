// SPDX-License-Identifier: MIT
pragma solidity >=0.8.3;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ChipToken is ERC20 {
    constructor() ERC20("ChipToken", "CHIP") {
        _mint(msg.sender, 3000000 * 18**decimals());
    }
}