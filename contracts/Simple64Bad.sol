// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;


import "./Base64.sol";



contract Simple {
    string myValue;
    
    // 49370 gas
    function setValue(string memory a, string memory b) public {
        myValue = Base64.encode(abi.encodePacked(a, " ", b));
    }

    function getValue() public view returns (string memory) {
        return myValue;
    }
}