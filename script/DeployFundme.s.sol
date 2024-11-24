// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
contract DeployFundMe is Script {
    FundMe public fundme;

    function run() public returns (FundMe) {
        HelperConfig helper = new HelperConfig();
        (address pricefeed) = helper.ActiveNetworkconfig();

        vm.startBroadcast();
        fundme = new FundMe(pricefeed);
        vm.stopBroadcast();
        return fundme;
    }
}
