// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

struct Transaction {
    string action;
    uint value;
}

interface IDrinkMachineWallet {
    function buy() external payable;
    function getBalance(address _address) external returns (uint);
}