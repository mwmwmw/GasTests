// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;


import "./Base64.sol";

contract Simple {
    string myValue;
    function setValue(string memory a, string memory b) public {
        myValue = string(abi.encodePacked(a, " ", b));
    }

    function getValue() public view returns (string memory) {
        return myValue;
    }
}