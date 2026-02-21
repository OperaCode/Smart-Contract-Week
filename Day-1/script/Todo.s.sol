// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Todo} from "../src/Todo.sol";

contract DeployTodo is Script {
    Todo public todo;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        todo = new Todo();

        vm.stopBroadcast();
    }
}
