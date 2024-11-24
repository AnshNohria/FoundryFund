// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Script, console } from 'forge-std/Script.sol';
import { FundMe } from '../src/FundMe.sol';
import { HelperConfig } from './HelperConfig.s.sol';
import { DevOpsTools } from 'foundry-devops/src/DevOpsTools.sol';

contract FundToFundMe is Script {
  function fundToFundMe(address recentDeployed) public {
    vm.startBroadcast();
    FundMe(payable(recentDeployed)).fund{ value: 1e17 }();
    vm.stopBroadcast();
  }

  function run() public {
    address recentDeployed = DevOpsTools.get_most_recent_deployment(
      'FundMe',
      block.chainid
    );

    fundToFundMe(recentDeployed);
  }
}

contract WithdrawFundMe is Script {
  function withdrawFundMe(address recentDeployed) public {
    vm.startBroadcast();
    FundMe(payable(recentDeployed)).withdraw();
    vm.stopBroadcast();
  }

  function run() public {
    address recentDeployed = DevOpsTools.get_most_recent_deployment(
      'FundMe',
      block.chainid
    );

    withdrawFundMe(recentDeployed);
  }
}
