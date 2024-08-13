//SPDX-License-Identifer: MIT

//Lending and borrowing
//Address > struct name + price
//User will submit itself with their name and the amount they want to receive.
//then the owner will the user for theat amount
//mapping, struct, events

//setting up the layout of the contract;

pragma solidity ^0.8.20;

error notOwner(address expected, address received);
error TransactionFailed(string message);
error UserDoesNotExist(string message);

contract fund {

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert notOwner(owner, msg.sender);
        }
        _;
    }

    //owner address
    address private immutable owner;

    //struct for the receivers
    struct Receivers {
        string ReceiverName;
        uint256 RequiredAmount;
    }


    // events
    event Borrowers(
        string indexed name,
        uint256 indexed amount,
        address indexed borrowerAddress
    );
    event TransactionConfirmation(address receiver, uint256 amount);

    // Instance of the struct
    // funders public Borrowers;

    // mapped user address to the username and required value
    mapping(address => Receivers) public BorrowerMapping;

    // will assigen the deployer as the contract owner.
    constructor() {
        owner = msg.sender;
    }

    //submitting the request for receiving the funds

    function submitRequest(string memory name, uint256 amount) public {
        // creating a in memory struct that gets appened to mapping

        Receivers memory receiverStruct = Receivers({
            ReceiverName: name,
            RequiredAmount: amount
        });

        //  mapping the struct to the address
        BorrowerMapping[msg.sender] = receiverStruct;

        //  emitting the event
        emit Borrowers(name, amount, msg.sender);
    }

    function transfer(address receiver) public payable onlyOwner {

        Receivers memory PersonToReceive = BorrowerMapping[receiver];
        uint256 amountToSend = PersonToReceive.RequiredAmount;

        (bool success, ) = receiver.call{value: amountToSend}("");
        if (!success) {
            revert TransactionFailed("Failed due to unexpected reason");
        }
        emit TransactionConfirmation(receiver, amountToSend);
    }

    // function for the contract to receive the funds
    receive() external payable {}

    // getters
    function getOwner() public view returns (address) {
        return owner;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getUser(address user) public view returns (string memory name) {
        Receivers memory PersonToReceive = BorrowerMapping[user];
        if(bytes(PersonToReceive.ReceiverName).length == 0){
            revert UserDoesNotExist("User does not exist");
        }
        return PersonToReceive.ReceiverName;
    }
}
