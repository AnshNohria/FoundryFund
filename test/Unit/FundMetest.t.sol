// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test , console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundme.s.sol";

contract FundMetest is Test {
    FundMe public fundme;
    address public constant USER = address(1);
    function setUp() external {
    //fundme = new FundMe();
    DeployFundMe deploy = new DeployFundMe();
    fundme = deploy.run();
    vm.deal(USER , 2e18);
    }

    function testMinimumDollarisfive() public view {
        uint256 actual = fundme.MINIMUM_USD();
        assertEq(actual, 5e18);
    }
    function testOwner() public view {
        address actual = fundme.i_owner();
        assertEq(actual, msg.sender);
    }
    function testpricefeedVersion() public view {
        uint256 actual = fundme.getVersion();
        assertEq(actual, 4);
    }
    function testfundshouldfail() public {
        vm.expectRevert();
        fundme.fund();
    }
function testfundupdates() public {
    vm.prank(USER);
    fundme.fund {value :1e17}();

uint256 amountFunded = fundme.addressToAmountFunded(USER);
assertEq(amountFunded, 1e17);
}
modifier funded(){
    vm.prank(USER);
    fundme.fund {value :1e17}();
    assert(fundme.addressToAmountFunded(USER) > 0);
    vm.stopPrank();
    _;
}
function testOnlyOwnerCanWithdraw() public funded {
    uint256 startingfundbalance = address(fundme).balance;
    uint256 startingownerbalance = fundme.i_owner().balance;
    vm.prank(fundme.i_owner());
    fundme.withdraw();

    uint256 endingfundbalance = address(fundme).balance;
    uint256 endingownerbalance = fundme.i_owner().balance;
    assertEq(endingfundbalance, 0);
    assertEq(endingownerbalance, startingownerbalance + startingfundbalance);
}
function testWithMultipleFunders() public funded {
    uint160 Totalfunders = 10;
    uint160 Startingfunderindex = 1;
    for (uint160 i = Startingfunderindex; i < Totalfunders; i++) {
        hoax(address(i) , 2e18);
        fundme.fund {value :1e17}();
    }
    uint256 startingfundbalance = address(fundme).balance;
    uint256 startingownerbalance = fundme.i_owner().balance;
    vm.prank(fundme.i_owner());
    fundme.withdraw();

    uint256 endingfundbalance = address(fundme).balance;
    uint256 endingownerbalance = fundme.i_owner().balance;
    assertEq(endingfundbalance, 0);
    assertEq(endingownerbalance, startingownerbalance + startingfundbalance);
}

}
