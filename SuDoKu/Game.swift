//
//  Game.swift
//  SuDoKu
//
//  Created by Ahmad Ragab on 12/27/15.
//  Copyright © 2015 Ahmad Ragab. All rights reserved.
//

import Foundation

class Game {
    var answer = Array(repeating: Array<Int>(repeating: 0, count: 9), count: 9)
    var puzzle = Array(repeating: Array<Int>(repeating: 0, count: 9), count: 9)
    var solve  = Array(repeating: Array<Int>(repeating: 0, count: 9), count: 9)
    var gameDiff = 0
    
    func setGameLevel(_ gameLevel: Int, sudoku: Array<Array<Int>>) -> Array<Array<Int>> {
        var sudoku = sudoku
        self.gameDiff = gameLevel
        
        for _ in 0 ... self.gameDiff * 10 {
            let r = Int(arc4random().advanced(by: Int(arc4random()) % 9) % 9)
            let c = Int(arc4random().advanced(by: Int(arc4random()) % 9) % 9)
            sudoku[r][c] = 0;
        }
        return sudoku
    }
    
    
    //Check user's solution with the unique right solution
    //------------------------------------------------------
    func checkSln(_ sudoku: Array<Array<Int>>) -> Array<(i:Int, j:Int)> {
        var worngTiles = Array<(i:Int, j:Int)>()
        
        for i in 0 ..< sudoku.count {
            for j in 0 ..< sudoku[i].count {
                if sudoku[i][j] != self.answer[i][j] {
                    worngTiles.append((i, j))
                }
            }
        }
        return worngTiles;
    }
    //------------------------------------------------------------------------------------------------
    
    
    //Create Full Sudoku Grid with random values fulfilling the rules of Sudoku game
    //--------------------------------------------------------------------------------
    func createTable(_ x: Int, y: Int) -> Int {
        var tab = Array<Int>(repeating: 1, count: 9)
        
        for i in 0 ..< x {
            tab[self.answer[i][y] - 1] = 0
        }
        
        for i in 0 ..< y {
            tab[self.answer[x][i] - 1] = 0
        }
        
        for i in (3 * (x / 3)) ..< (3 * (x / 3) + 3) {
            for j in (3 * (y / 3)) ..< y {
                tab[self.answer[i][j] - 1] = 0
            }
        }
        
        var size = 0
        for i in 0 ..< 9 {
            size += tab[i]
        }
        
        var tab_ptr = Array<Int>(repeating: 0, count: size)
        var i = 0
        var j = 0
        while (true) {
            if i >= 9 {
                break
            }
            
            if tab[i] == 1 {
                tab_ptr[j] = i + 1
                j += 1
            }
            
            i = i + 1
        }
        
        var pos_x = 0
        var pos_y = 0
        if x == 8 {
            pos_x = 0
            pos_y = y + 1
        } else {
            pos_x = x + 1
            pos_y = y
        }
        
        var r = 0
        while size > 0 {
            r = Int(arc4random()) % size
            self.answer[x][y] = tab_ptr[r]
            tab_ptr[r] = tab_ptr[size - 1]
            
            size -= 1
            
            if x == 8 && y == 8 {
                return 1
            }
            if self.createTable(pos_x, y: pos_y) == 1 {
                return 1
            }
        }
        return 0
    }
    //------------------------------------------------------------------------------------------------
    
    
    //Solve Sudoku Grid
    //-------------------
    func IsValid(_ row: Int, col: Int, n: Int) -> Bool {
        let row_start = (row / 3) * 3;
        let col_start = (col / 3) * 3;
        
        for i in 0 ..< 9 {
            if self.solve[row][i] == n || self.solve[i][col] == n || self.solve[row_start + (i % 3)][col_start + (i / 3)] == n {
                return false;
            }
        }
        return true;
    }
    
    func SolveSudoku(_ row: Int, col: Int) -> Bool
    {
        if (row < 9 && col < 9) {
            if self.solve[row][col] != 0 {
                if (col + 1) < 9 {
                    return SolveSudoku(row, col: col + 1);
                } else if (row + 1) < 9 {
                    return SolveSudoku(row + 1, col: 0);
                } else {
                    return true;
                }
            } else {
                for i in 0 ... 9 {
                    if IsValid(row, col: col, n: i + 1) {
                        self.solve[row][col] = i + 1;
                        if (col + 1) < 9 {
                            if SolveSudoku(row, col: col + 1) {
                                return true;
                            } else {
                                self.solve[row][col] = 0;
                            }
                        } else if (row + 1) < 9 {
                            if SolveSudoku(row + 1, col: 0) {
                                return true;
                            } else {
                                self.solve[row][col] = 0;
                            }
                        } else {
                            return true;
                        }
                    }
                }
            }
            return false;
        } else {
            return true;
        }
    }
    //------------------------------------------------------------------------------------------------
    
    
//    func Hide()
//    {
//        let i = random() % 9;
//        let j = random() % 9;
//        
//        if self.puzzle[i][j] != 0 {
//            self.puzzle[i][j] = 0;
//        }
//        
//        CopySolvePuzzle();
//        SolveSudoku(0, col: 0);
//        
//        if !Unique() {
//            Hide();
//        }
//    }
    
//    func CopyPuzzleAnswer() {
//        for (var i = 0; i < 9; ++i) {
//            for (var j = 0; j < 9; ++j) {
//                self.puzzle[i][j] = self.answer[i][j];
//            }
//        }
//    }
    
//    func CopySolvePuzzle() {
//        for (var i = 0; i < 9; ++i) {
//            for (var j = 0; j < 9; ++j) {
//                self.solve[i][j] = self.puzzle[i][j];
//            }
//        }
//    }
    
//    func CopyPuzzleSolve() {
//        for (var i = 0; i < 9; ++i) {
//            for (var j = 0; j < 9; ++j) {
//                self.puzzle[i][j] = self.solve[i][j];
//            }
//        }
//    }
    
//    func Unique() -> Bool {
//        for (var i = 0; i != 9; ++i){
//            for (var j = 0; j != 9; ++j){
//                if self.solve[i][j] != self.answer[i][j] {
//                    return false;
//                }
//            }
//        }
//        return true;
//    }
    
}
