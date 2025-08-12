// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "../DrinkMachineWallet/IDrinkMachineWallet.sol";
import "./Structs.sol";

contract DrinkMachine {
    IDrinkMachineWallet public wallet;
    address public owner;
    ProductType[5] internal products;
    enum ProductEnum {Water, Tea, Juice, Milk, Coffee}

    constructor(address _wallet) {
        owner = msg.sender;
        wallet = IDrinkMachineWallet(_wallet);
        products[0] = ProductType("water", "Water", 1 wei, 100);
        products[1] = ProductType("tea", "Tea", 2 wei, 100);
        products[2] = ProductType("juice", "Juice", 3 wei, 100);
        products[3] = ProductType("milk", "Milk", 4 wei, 100);
        products[4] = ProductType("coffee", "Coffee", 5 wei, 100);
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can call this resource.");
        _; // lanjut eksekusi fungsi jika kondisi terpenuhi
    }

    function addProduct(ProductEnum productEnum, uint quantity) public onlyOwner {
        products[uint(productEnum)].quantity += quantity;
    }

    function getInfoProduct(ProductEnum productEnum) public view returns (ProductType memory){
        return products[uint(productEnum)];
    }

    function buy(ProductEnum productEnum, uint qty) public payable {
        uint index = uint(productEnum);
        uint total = products[uint(productEnum)].price * qty;
        require(index >= 0 || index < products.length, "Invalid product enum"); // jika kondisi terpenuhi maka akan di lanjutkan
        require(products[index].quantity >= qty, "Product not enough."); // jika kondisi tidak terpenuhi maka akan ter trigger error
        require(msg.value >= total, "Not enough ether");

        products[index].quantity -= qty;

        // kirim saldo ke owner
        payable(owner).transfer(total);
    }

    function withdrawAllFunds() public payable onlyOwner {
        require(address(this).balance > 0, "No funds to withdraw.");
        payable(owner).transfer(address(this).balance);
    }
}