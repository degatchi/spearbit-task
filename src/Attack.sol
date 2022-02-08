// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Attack {
    function attack(address des) public payable {
        selfdestruct(payable(des));
    }

    uint256 public num = 10;

    function work(uint256 _num) public {
        num = _num;
    }
}
