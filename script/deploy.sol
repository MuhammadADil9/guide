//SPDX-License-Identifier:MIT

pragma solidity^0.8.18;

import {Script} from "forge-std/Script.sol";
import {fund} from "../src/contract.sol";

contract deploy is Script{
    fund public FundContract;
    function run() public returns(fund){
        
        vm.startBroadcast();  /* This will spun a chain on which contract will be deployed */
        FundContract = new fund();
        vm.stopBroadcast();
        
        return FundContract;
    }

}