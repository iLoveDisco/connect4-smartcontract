pragma solidity >=0.7.0 <0.9.0;

contract Game {
    uint WIN_COND = 4;
    
    string EMPTY = '.';
    string RED = 'R';
    string YELLOW = 'Y';
    
    uint NUM_COLS = 7;
    uint NUM_ROWS = 6;
    
    SLOT_STATE[6][7] board;
    
    enum GAME_STATE{ P1_TURN, P2_TURN, WAITING }
    enum SLOT_STATE { YELLOW, RED, EMPTY }
    
    GAME_STATE gameState = GAME_STATE.WAITING;
    address p1;
    address p2;
    
    constructor() {
        resetBoard();
    }
    
    function resetBoard() private {
        for (uint i = 0; i < NUM_COLS; i++) {
            for (uint j = 0; j < NUM_ROWS; j++) {
                board[i][j] = SLOT_STATE.EMPTY;
            }
        }
    }
    
    /**
     * insert(uint column) receives a column number
     * 
     * 'inserts' the chip to the specified slot on the board
    */
    function insert(uint column) public returns (string memory){
        
        // check that the right people are calling this function
        if (gameState == GAME_STATE.P1_TURN) {
            require(msg.sender == p1, "It is player 1's turn");
        }
        
        if (gameState == GAME_STATE.P2_TURN) {
            require(msg.sender == p2, "It is player 2's turn");
        }
        
        if (gameState == GAME_STATE.WAITING) {
            require(gameState != GAME_STATE.WAITING, "Game needs 2 players to start");
        }
        
        
        SLOT_STATE[6] memory col = board[column];
        require(col[NUM_ROWS - 1] == SLOT_STATE.EMPTY, "Column is full");
        
        uint i = 0;
        while(i < NUM_ROWS && col[i] != SLOT_STATE.EMPTY) {
            i = i + 1;
        }
        
        col[i] = getColor();
        board[column] = col;
        
        // adjust the game state according to who just moved
        if (gameState == GAME_STATE.WAITING || gameState == GAME_STATE.P2_TURN) {
            gameState = GAME_STATE.P1_TURN;
        } else if (gameState == GAME_STATE.P1_TURN) {
            gameState = GAME_STATE.P2_TURN;
        }
        
        return checkForWin();
    }
    
    function checkForWin() private returns (string memory) {
        // TODO: Implement Me!
        
        string memory P1_WIN_MSG = "Player 1 wins!";
        string memory P2_WIN_MSG = "Player 2 wins!";
        
        bool isWin = checkRows() || checkCols();
        
        
        // Player 1 just went
        if (gameState == GAME_STATE.P2_TURN && isWin) {
            endGame();
            return "Player 1 wins!";
        }
        
        // Player 2 just went
        if (gameState == GAME_STATE.P1_TURN && isWin) {
            endGame();
            return "Player 2 wins!";
        }
        
        if (checkTie()) {
            endGame();
            return "It is a tie!";
        }
        
        return "No winner";
    }
    
    function endGame() private {
        gameState = GAME_STATE.WAITING;
        p1 = address(0);
        p2 = address(0);
        resetBoard();
    }
    
    function checkRows() private returns (bool) {
        bool output = false;
        for (uint i = 0; i < NUM_ROWS; i++) {
            for (uint j = 0; j < NUM_COLS - 3; j++) {
                output = output || ((board[j][i] != SLOT_STATE.EMPTY) && (board[j][i] == board[j + 1][i]) && (board[j + 1][i] == board[j+2][i]) && (board[j+2][i] == board[j+3][i]));
            }
        }
        return output;
    }
    
    function checkCols() private returns (bool) {
        bool output = false;
        for (uint i = 0; i < NUM_COLS; i++) {
            for (uint j = 0; j < NUM_ROWS - 3; j++) {
                output = output || ((board[i][j] != SLOT_STATE.EMPTY) && (board[i][j] == board[i][j+1]) && (board[i][j+1] == board[i][j+2]) && (board[i][j+2] == board[i][j+3]));
            }
        }
        return output;
    }
    
    function checkTie() private returns (bool) {
        bool output = false;
        for (uint i = 0; i < NUM_ROWS; i++) {
            for (uint j = 0; j < NUM_COLS; j++) {
                output = output && (board[i][j] != SLOT_STATE.EMPTY);
            }
        }
        return output;
    }
    
    /**
     * getColor() returns a color based on whos turn it is
    * 
    */
    function getColor() private returns (SLOT_STATE) {
        if (gameState == GAME_STATE.P1_TURN) {
            return SLOT_STATE.YELLOW;
        }
        return SLOT_STATE.RED;
    }
    
    
    // Low gas concat function found here: 
    // https://ethereum.stackexchange.com/questions/729/how-to-concatenate-strings-in-solidity
    function concat(string memory a, string memory b) private pure returns (string memory) {
        return string(abi.encodePacked(a, b));
    }
    
    // mainly used for debugging
    function getBoardString() public returns (string memory) {
        
        string memory boardString = "";
        
        for (uint i = 0; i < NUM_COLS; i++) {
            for (uint j = 0; j < NUM_ROWS; j++) {
                SLOT_STATE slotState = board[i][j];
                
                string memory concatString;
                if (slotState == SLOT_STATE.YELLOW) {
                    concatString = "Y";
                } else if (slotState == SLOT_STATE.RED) {
                    concatString = "R";
                } else {
                    concatString = ".";
                }
                
                boardString = concat(boardString, concatString);
            }
            boardString = concat(boardString,"\n");
        }
        
        return boardString;
    }
    
    
    function joinGame() public returns (string memory){
        require(p1 == address(0) || p2 == address(0),"Game is full");
        require(p1 != msg.sender && p2 != msg.sender,"Player has already joined the game");
        
        string memory outputMsg = "";
        
        if (p1 == address(0)) {
            p1 = msg.sender;
            outputMsg = "P1 has joined!";
        } else if (p2 == address(0)) {
            p2 = msg.sender;
            outputMsg = "P2 has joined!";
        }
        
        if (p1 != address(0) && p2 != address(0)) {
            gameState = GAME_STATE.P1_TURN;
            outputMsg = "Both players have joined! P1 goes first";
        }
        
        return outputMsg;
    }
}
