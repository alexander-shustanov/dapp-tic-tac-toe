pragma solidity ^0.4.17;

contract TicTacToe {
    
    struct Game {
        address first;
        address second;
        // if true -> first player made turn
        bool turn;
        uint[9] deck;
        uint winner;
    }
    
    address public owner;
    mapping(int => Game) games;
    mapping(address => int) participations;
    
    int gameNumber;

    constructor() public {
        owner = msg.sender;
        
        gameNumber = 1;
    }
    
    modifier restricted() {
        if (msg.sender == owner) _;
    }
    
    modifier participated() {
        require(participations[msg.sender] != 0);
        
        _;
    }
    
    function enter() public returns (int) {
        require(participations[msg.sender] == 0);
        
        participations[msg.sender] = gameNumber;
        Game storage game = getMyGame();
        
        if(game.first == 0x0) {
            game.first = msg.sender;
            return gameNumber;
        } else {
            game.second = msg.sender;
            gameNumber += 1;
            
            return gameNumber - 1;
        }
    }
    
    function turn(uint col, uint row) public participated {
        Game storage game = getMyGame();
        require(col >= 0 && col <= 2 && row >= 0 && row <= 2);
        
        require(game.second != 0x0);
        
        uint index = row  * 3 + col;
        
        require(game.deck[index] == 0);
        
        uint myMark = 0;
        if(game.first == msg.sender) 
            myMark = 1;
        else
            myMark = 2;
            
        if(game.turn && game.second == msg.sender) {
            game.deck[index] = myMark;
            game.turn = false;
        } else if(!game.turn && game.first == msg.sender) {
            game.deck[index] = myMark;
            game.turn = true;
        } else {
            revert();
        }
        
        if(hasWon(game.deck, myMark)) {
            game.winner = myMark;
            participations[game.first] = 0;
            participations[game.second] = 0;
        }
    }
    
    function hasWon(uint[9] deck, uint mark) private pure returns (bool) {
        uint8[24] memory winPositions = [0,1,2,3,4,5,6,7,8,0,3,6,1,4,5,2,6,8,0,4,8,2,4,6];
        
        for(uint i=0;i<6;i++) {
            uint start = i*3;
            
            if(deck[winPositions[start]] == mark && deck[winPositions[start + 1]] == mark && deck[winPositions[start + 2]] == mark)
                return true;
        }
        
        return false;
    }
    
    function getMyGame() private view participated returns (Game storage) {
        return games[participations[msg.sender]];
    }
}