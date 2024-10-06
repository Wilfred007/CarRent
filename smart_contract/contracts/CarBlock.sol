// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract CarBlock {

    address owner;

    constructor() {
        owner = msg.sender;
    }

    // Add yourself as a Renter
    // This s firstName;

    // string struct adds the renter's details and initiates rental

    struct Renter {
        address payable walletAddress;
        string firstName;
        string lastName;
        bool canRent;
        bool active;
        uint balance;
        uint due;
        uint start;
        uint end;
    }

    mapping (address => Renter) public renters;

    function addRenter(address payable walletAddress, string memory firstName, string memory lastName, bool canRent, bool active, uint balance, uint due, uint start, uint end) public {
        renters[walletAddress] = Renter(walletAddress, firstName, lastName, canRent, active, balance, due, start, end);
    }

    // Checkout vehicle
    function checkOut(address walletAddress) public {
        require(renters[walletAddress].due == 0, "Pending balance.");
        require(renters[walletAddress].canRent == true, "Sorry");
        renters[walletAddress].active = true;
        renters[walletAddress].start = block.timestamp;
        renters[walletAddress].canRent = false;
    }

    // Check in a vehicle
    function checkIn(address walletAddress) public {
        require(renters[walletAddress].active == true, "check out a car first.");
        renters[walletAddress].active = false;
        renters[walletAddress].end = block.timestamp;
        setDue(walletAddress);
    }

    // Get the total ammount of time of car use
    function renterTimespan(uint start, uint end) internal pure returns(uint) {
        return end - start;
    }

    function getTotalDuration(address walletAddress) public view returns(uint) {
        if (renters[walletAddress].start==0 || renters[walletAddress].end==0){
            return 0;
        } else {
            uint timespan = renterTimespan(renters[walletAddress].start, renters[walletAddress].end);
            uint timespanInMinutes = timespan / 60;
            return timespanInMinutes;
        }
        
    }

    // Get Contract balance
    function balanceOf() view public returns(uint) {
        return address(this).balance;
    }

    // Get Renter's balance
    function balanceOfRenter(address walletAddress) public view returns(uint) {
        return renters[walletAddress].balance;
    }

    // Set Due amount
    function setDue(address walletAddress) internal {
        uint timespanMinutes = getTotalDuration(walletAddress);
        uint fiveMinuteIncrements = timespanMinutes / 5;
        renters[walletAddress].due = fiveMinuteIncrements * 5000000000000000;
    }

    function canRentCar(address walletAddress) public view returns(bool) {
        return renters[walletAddress].canRent;
    }

    // Deposit
    function deposit(address walletAddress) payable public {
        renters[walletAddress].balance += msg.value;
    }

    // Make Payment
    function makePayment(address walletAddress) payable public {
        require(renters[walletAddress].due > 0, "You do not have anything due at this time.");
        require(renters[walletAddress].balance > msg.value, "Please make a deposit.");
        renters[walletAddress].balance -= msg.value;
        renters[walletAddress].canRent = true;
        renters[walletAddress].due = 0;
        renters[walletAddress].start = 0;
        renters[walletAddress].end = 0;
    }

    function getDue (address walletAdress) public view returns(uint) {
        return renters[walletAdress].due;
    }

    function getRenter(address walletAddress) public view returns (string memory firstName, string memory lastName, bool canRent, bool active) {
        firstName = renters[walletAddress].firstName;
        lastName = renters[walletAddress].lastName;
        canRent = renters[walletAddress].canRent;
        active = renters[walletAddress].canRent;
    }

    function renterExist (address walletAddress) public view returns (bool) {
        if (renters[walletAddress].walletAddress != address(0)){
        return true;
        }
         return false;
    }
   
}