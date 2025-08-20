// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "./IDrinkMachineWallet.sol";

contract DrinkMachineWallet {
    using Strings for uint256;

    mapping(address => uint) internal balance;

    event DepositEvent(address indexed user, uint value, string message, uint timestamp);
    event BuyEvent(address indexed user, uint value, string message, string productEnum);
    
    constructor() {
        balance[msg.sender] = 0 wei;
    }

    modifier DepositMiddleware(){
        require(msg.value >= 1 wei, "Saldo anda kurang dari minimum deposit (1 wei).");
        _;
    }

    modifier BuyMiddleware(){
         require (msg.value <= balance[msg.sender], "Saldo anda tidak mencukupi untuk membeli minuman ini.");
         _;
    }

    function deposit() public payable DepositMiddleware returns(string memory, string memory) {
        balance[msg.sender] += msg.value;

        return (
            "Your Deposit Success!", 
            string(abi.encodePacked("Your balance: ", balance[msg.sender].toString(), " Wei"))
        );
    }

    function buy() external payable BuyMiddleware {
        balance[msg.sender] -= msg.value;
    }

    function getBalance() external view returns(uint) {
        return balance[msg.sender];
    }
}