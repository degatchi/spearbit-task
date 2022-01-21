// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import {DSTest} from "ds-test/test.sol";
import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
import {Hevm} from "./utils/Hevm.sol";

import {Implementation} from "../Implementation.sol";
import {Proxy} from "../Proxy.sol";

contract ContractTest is DSTest {
    Hevm internal immutable hevm = Hevm(HEVM_ADDRESS);

    Utilities internal utils;
    address payable[] internal users;


    Implementation internal IMPLEMENTATION;
    Proxy internal PROXY;

    function setUp() public {
        utils = new Utilities();
        users = utils.createUsers(5);

        IMPLEMENTATION = new Implementation();
        PROXY = new Proxy(address(IMPLEMENTATION), users[0]);
    }

    function test_exploit() public {

    }
    
    // function testExample() public {
    //     address payable alice = users[0];
    //     console.log("alice's address", alice);
    //     address payable bob = users[1];
    //     hevm.prank(alice);
    //     (bool sent, ) = bob.call{value: 10 ether}("");
    //     assertTrue(sent);
    //     assertGt(bob.balance, alice.balance);
    // }
}
