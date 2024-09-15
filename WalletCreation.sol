// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleWallet {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {}

    function withdraw(uint256 _amount) public {
        require(msg.sender == owner, "Only the owner can withdraw");
        require(address(this).balance >= _amount, "Insufficient balance");
        payable(owner).transfer(_amount);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
