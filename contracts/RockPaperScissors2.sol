// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./Base64.sol";

struct Game {
    address p1;
    address p2;
    uint256 p1fate;
    uint256 p2fate;
}

contract RPS {
    uint256 public gameCount;
    mapping(uint256 => Game) public games;

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

        Game memory game;
        game.p1 = player1;
        game.p2 = player2;
        game.p1fate = uint256(
            keccak256(
                abi.encodePacked(
                    gameCount,
                    player1,
                    block.difficulty,
                    block.timestamp
                )
            )
        )%3;
        game.p2fate = uint256(
            keccak256(
                abi.encodePacked(
                    gameCount,
                    player2,
                    block.difficulty,
                    block.timestamp
                )
            )
        )%3;

        games[gameCount++] = game;
    
    }

    function getGame(uint256 gameId) public view returns (string memory) {

        Game memory game = games[gameId];
        string memory result;
        
        
        if(game.p1fate == 0 && game.p2fate == 2 || game.p1fate == 1 && game.p2fate == 0 || game.p1fate == 2 && game.p2fate == 1) {
            result = "Player 1 Wins";
        }

        if(game.p2fate == 0 && game.p1fate == 2 || game.p2fate == 1 && game.p1fate == 0 || game.p2fate == 2 && game.p1fate == 1) {
            result = "Player 2 Wins";
        }    

        if(game.p2fate == 0 && game.p1fate == 0 || game.p2fate == 1 && game.p1fate == 1 || game.p2fate == 2 && game.p1fate == 2) {
            result  = "Draw";
        }   


        return string(abi.encodePacked(
                    '{"player1":"',
                    toString(game.p1),
                    '","player2":"',
                    toString(game.p2),
                    '","result":"',
                    result,
                    '"}'
                ));

    }

}