// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./Structs.sol";

contract DrinkMachineWallet {
    using Strings for uint256;

    mapping(address => uint) internal balance;
    mapping(address => Transaction[]) public transactions;
    
    constructor() {
        deposit();
    }

    modifier DepositMiddleware(){
        require(msg.value >= 1 gwei, "Saldo anda kurang dari minimum deposit (1 gwei).");
        _;
    }

    function deposit() public payable DepositMiddleware returns(string memory, string memory) {
        balance[msg.sender] += msg.value;

        transactions[msg.sender].push(Transaction("Deposit", msg.value));
        return (
            "Your Deposit Success!", 
            string(abi.encodePacked("Your balance: ", balance[msg.sender].toString(), " Wei"))
        );
    }

    function buy() external payable {
        
    }
}