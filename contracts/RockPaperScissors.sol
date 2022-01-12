// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./Base64.sol";

struct Game {
    address p1;
    address p2;
    string result;
}

// GAS COST 1 = 176749

// GAS COST 2 = 96377

// GAS COST 3 = 133765 ????

contract RPS {
    uint256 public gameCount;
    mapping(uint256 => string) public games;

    function toString(address account) public pure returns(string memory) {
        return toString(abi.encodePacked(account));
    }

    function toString(bytes memory data) public pure returns(string memory) {
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(2 + data.length * 2);
        str[0] = "0";
        str[1] = "x";
        for (uint i = 0; i < data.length; i++) {
            str[2+i*2] = alphabet[uint(uint8(data[i] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
        }
        return string(str);
    }

    function Play(address player1, address player2) public {

        uint256 p1fate = uint256(
            keccak256(
                abi.encodePacked(
                    gameCount,
                    player1,
                    block.difficulty,
                    block.timestamp
                )
            )
        )%3;
        uint256 p2fate = uint256(
            keccak256(
                abi.encodePacked(
                    gameCount,
                    player2,
                    block.difficulty,
                    block.timestamp
                )
            )
        )%3;

        string memory result = "dw";

        if(p1fate == 0 && p2fate == 2 || p1fate == 1 && p2fate == 0 || p1fate == 2 && p2fate == 1) {
            result  = "p1";
        }

        if(p2fate == 0 && p1fate == 2 || p2fate == 1 && p1fate == 0 || p2fate == 2 && p1fate == 1) {
            result  = "p2";
        }   

        games[gameCount++] = string(abi.encodePacked(
                    '{"player1":"',
                    toString(player1),
                    '","player2":"',
                    toString(player1),
                    '","result":"',
                    result,
                    '"}'
                ));
    
    }

    function getGame(uint256 gameId) public view returns (string memory) {
        return games[gameId];
    }

}