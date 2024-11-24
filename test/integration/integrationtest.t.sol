// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { FundMe } from "../../src/FundMe.sol";
import { DeployFundMe } from "../../script/DeployFundme.s.sol";
import { FundToFundMe, WithdrawFundMe } from "../../script/Interactive.s.sol";
import { Test } from "forge-std/Test.sol";

contract IntegrationTest is Test {
    FundMe fundme;
    address public USER = makeAddr("USER");

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundme = deploy.run();
    }

    function testUsersCanFund() public {
        FundToFundMe fund = new FundToFundMe();
        fund.fundToFundMe(address(fundme));
        WithdrawFundMe withdraw = new WithdrawFundMe();
        withdraw.withdrawFundMe(address(fundme));
        assert(address(fundme).balance == 0);


    }
}
