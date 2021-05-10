pragma solidity >=0.7.0 <0.9.0;

contract Game {
    uint WIN_COND = 4;
    
    string EMPTY = '.';
    string RED = 'R';
    string YELLOW = 'Y';
    
    uint NUM_COLS = 7;
    uint NUM_ROWS = 6;
    
    SLOT_STATE[6][7] board;
    
    enum STATE{ P1_TURN, P2_TURN, WAITING }
    enum SLOT_STATE { YELLOW, RED, EMPTY }
    
    address whosTurn;
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
    function insert(uint column) public {
        SLOT_STATE[6] memory col = board[column];
        // TODO Refactor board so that it uses enums rather Strings
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
    
    
    function joinGame(address playerAlias) public{
        
    }
    
}