// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;    

import {Script, console} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
contract HelperConfig is Script {

NetworkConfig public ActiveNetworkconfig;

    struct NetworkConfig {
        address priceFeed; 
    }
    constructor() {
        if (block.chainid == 11155111) {
            ActiveNetworkconfig = getSepoliaEthConfig();
        } else {
        ActiveNetworkconfig = getAnvilEthConfig();
    }
    }
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
    return NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
    }

    function getAnvilEthConfig() public returns (NetworkConfig memory) {
        if (ActiveNetworkconfig.priceFeed != address(0)) {
            return ActiveNetworkconfig;
        }
vm.startBroadcast();
    MockV3Aggregator mock = new MockV3Aggregator(8, 2000e8);
    vm.stopBroadcast();
    NetworkConfig memory Anvilconfig = NetworkConfig({priceFeed: address(mock)});
    return Anvilconfig;
    }
}
