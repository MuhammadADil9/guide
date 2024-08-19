//SPDX-License-Identifider : MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {deploy} from "../script/deploy.sol";
import {fund} from "../src/contract.sol";
import {Vm} from "forge-std/Vm.sol";

contract test is Test {
    deploy public deployer;
    fund public fundContract;
    uint256 public amount;
    uint256 public counter;
    struct users {
        string name;
        uint256 amount;
        address userAddress;
    }

    users[] public people;

    address public addressOne;
    address public addressTwo;
    address public addressThree;

    string public nameOne = "adil";
    string public nameTwo = "asfar";
    string public nameThree = "bilal";

    uint256 public amountOne = 10 ether;
    uint256 public amountTwo = 5 ether;
    uint256 public amountThree = 3 ether;

    event Borrowers(
        string indexed name,
        uint256 indexed amount,
        address indexed borrowerAddress
    );
    event TransactionConfirmation(address receiver, uint256 amount);

    function setUp() public {
        deployer = new deploy();
        fundContract = deployer.run();
        amount = 20 ether;
        counter = 0;
    }

    modifier subscribes() {
        addressOne = vm.addr(1);
        addressTwo = vm.addr(2);
        addressThree = vm.addr(3);

        vm.prank(addressOne);
        fundContract.submitRequest(nameOne, amountOne);

        vm.prank(addressTwo);
        fundContract.submitRequest(nameTwo, amountTwo);

        vm.prank(addressThree);
        fundContract.submitRequest(nameThree, amountThree);

        people.push(
            users({name: nameOne, amount: amountOne, userAddress: addressOne})
        );

        people.push(
            users({name: nameTwo, amount: amountTwo, userAddress: addressTwo})
        );

        people.push(
            users({
                name: nameThree,
                amount: amountThree,
                userAddress: addressThree
            })
        );

        _;
    }

    function test_contractExistance() public {
        console.log("Contract deployed", address(fundContract));
    }

    //is user able to register itself done
    //is the transfer function functioning peoperly done
    //is the get owner functioning properly done
    //is the getuser function functioning properly done
    //gettng out the logs

    function test_userSubmission() public subscribes {
        (string memory name, , ) = fundContract.getUser(addressOne);
        // assertEq(name,nameOne);
        assert(
            keccak256(abi.encodePacked(name)) ==
                keccak256(abi.encodePacked(nameOne))
        );
    }

    function test_owner() public {
        assert(msg.sender == fundContract.getOwner());
    }

    //Why this function needs vm.prank(msg.sender) when every call is being made by the owner itselft only

    function test_transfer() public subscribes {
        address dummy = vm.addr(11);
        vm.deal(dummy, amount);
        (bool success, ) = address(fundContract).call{value: amount}("");
        vm.prank(msg.sender);
        fundContract.transfer(addressOne);
        (, , uint256 AmountToBeDeposit) = fundContract.getUser(addressOne);
        assert(amountOne == AmountToBeDeposit);
    }

    function test_events_Transfer() public {
        for (uint i = 0; i < people.length; i++) {
            vm.expectEmit(true, true, true, true);
            users memory temp = people[i];
            emit Borrowers(temp.name, temp.amount, temp.userAddress);
            vm.prank(temp.userAddress);
            fundContract.submitRequest(temp.name, temp.amount);
        }
    }

    function test_decoded_event() public {
        address dummy = vm.addr(20);
        string memory name = "ali";
        vm.prank(dummy);
        vm.recordLogs();
        emit Borrowers(name, 10, dummy);
        Vm.Log[] memory recordedData = vm.getRecordedLogs();
        assertEq(recordedData.length, 1);
        assertEq(
            recordedData[0].topics[0],
            keccak256("Borrowers(string,uint256,address)")
        );
        assertEq(recordedData[0].topics[1], keccak256(abi.encodePacked(name)));
    }
}
