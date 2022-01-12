// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;


import "./Base64.sol";

contract Simple {
    string myValue1;
    string myValue2;
    // 68687 gas 
    function setValue(string memory a, string memory b) public {
        myValue1 = a;
        myValue2 = b;
    }

    function getValue() public view returns (string memory) {
        return Base64.encode(abi.encodePacked(myValue1, " ", myValue2));
    }
}