// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract Middleware {
    modifier register(){
        require(msg.value < 1 gwei, "Saldo anda kurang dari minimum deposit.");
        _;
    }
}

contract Struct {
    struct Transaction {
        string action;
        uint value;
    }
}

contract DrinkMachineWallet is Middleware, Struct {
    mapping(address => uint) internal balances;
    mapping(address => Action)
    
    constructor() {
        register();
    }


    function register() public payable register {
        msg.sender
    }
}