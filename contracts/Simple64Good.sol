// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;


import "./Base64.sol";

contract Simple {
    bytes myValue;
    
    // 47174 gas 
    function setValue(string memory a, string memory b) public {
        myValue = abi.encodePacked(a, " ", b);
    }

    function getValue() public view returns (string memory) {
        return Base64.encode(myValue);
    }
}