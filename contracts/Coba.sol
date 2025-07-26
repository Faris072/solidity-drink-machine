// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract Animal {
    uint internal height;
    uint internal weight;
    string internal name;
    string internal foodType;

    constructor(string memory _name, string memory _foodType, uint _height,uint _weight){
        name = _name;
        height = _height;
        weight = _weight;
        foodType = _foodType;
    }

    function getData() public view returns (uint, uint, string memory, string memory){
        return (height, weight, name, foodType);
    }
}

contract Tiger is Animal {
    string internal sound;

    constructor(string memory _name, uint _height, uint _weight) Animal(_name, "Meat", _height, _weight) {
        sound = "Roarr";
    }

    function getDataAllData() public view returns (uint, uint, string memory, string memory, string memory){
        return (height, weight, name, foodType, sound);
    }
}