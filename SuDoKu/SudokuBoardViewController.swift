//
//  SudokuBoardViewController.swift
//  SuDoKu
//
//  Created by Ahmad Ragab on 12/27/15.
//  Copyright © 2015 Ahmad Ragab. All rights reserved.
//

import UIKit
import iAd

class SudokuBoardViewController: UIViewController, ADBannerViewDelegate
{
    @IBOutlet var tilesLabelCollection: [UILabel]!
    @IBOutlet var banner: UIView!
    
    let game = Game()
    var gameLevel = 0
    var puzzle = Array<Array<Int>>()
    var solve = Array<Array<Int>>()
    var toucedLabel = 0
    var originalColor : UIColor!
    var madeAppSolvePuzzle : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.originalColor = self.tilesLabelCollection[0].backgroundColor;
        prepGrid()
    }
    
    func generateGame() {
        if self.gameLevel > 0 {
            let _ = self.game.createTable(0, y: 0)
            self.puzzle = self.game.answer
            self.puzzle = self.game.setGameLevel(self.gameLevel, sudoku: self.puzzle)
        }
    }
    
    func prepGrid() {
        if self.puzzle.count != 0 {
            var labelIdx = 0
            for i in 0 ..< 9 {
                for j in 0 ..< 9 {
                    if self.puzzle[i][j] != 0 {
                        self.tilesLabelCollection[labelIdx].text = LanguageHandler.sharedInstance.stringForKey(key: "\(self.puzzle[i][j])")//"\(self.puzzle[i][j])"
                    }
                    labelIdx += 1
                }
            }
        }
    }
    
    func setTileColor (_ color: UIColor) {
        if self.toucedLabel > 0 {
            self.tilesLabelCollection[self.toucedLabel - 1].backgroundColor = color
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setTileColor(self.originalColor)
        
        let touch = touches.first
        self.toucedLabel = (touch?.view?.tag)!
        
        setTileColor(UIColor.green)
    }
    
    func fillPuzzleLocation(_ location: Int, number: Int) {
        if self.toucedLabel > 0 {
            if self.puzzle.count == 0 {
                self.puzzle = Array(repeating: Array<Int>(repeating: 0, count: 9), count: 9)
            }
            var div = location / 9
            var rem = location % 9 - 1
            if rem == -1 {
                div -= 1
                rem = 8
            }
            self.puzzle[div][rem] = number
        }
    }
    
    @IBAction func numberPressed(_ sender: AnyObject) {
        if self.toucedLabel > 0 {
            let tile = self.tilesLabelCollection[self.toucedLabel - 1]
            if tile.text == "" || tile.textColor == UIColor.red {
                self.tilesLabelCollection[self.toucedLabel - 1].text = LanguageHandler.sharedInstance.stringForKey(key: "\(sender.tag)")//"\(sender.tag)"
                self.tilesLabelCollection[self.toucedLabel - 1].textColor = UIColor.red
                let loc = self.tilesLabelCollection[self.toucedLabel - 1].tag
                fillPuzzleLocation(loc, number: sender.tag)
            } else {
                Utilities.showMessageIn(viewController: self, withTitle: "Error", andMessage: "You can't change this tile", andActionTitle: "Ok", andComplitionCode: false)
            }
        } else {
            Utilities.showMessageIn(viewController: self, withTitle: "Error", andMessage: "Please choose tile first", andActionTitle: "Ok", andComplitionCode: false)
        }
    }
    
    @IBAction func cancelPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    //-----------------------------------------------------------------------------------------------------------
    
    
    //For Check the solution
    //-----------------------
    @IBAction func checkSolutionPressed(_ sender: AnyObject) {
        if self.gameLevel != 0 {
            if boardHaveEmptyTiles(self.puzzle) {
                Utilities.showMessageIn(viewController: self, withTitle: "Wrong answer", andMessage: "Still have empty places, fill them first", andActionTitle: "Ok", andComplitionCode: false)
                return
            }
            
            if madeAppSolvePuzzle {
                Utilities.showMessageIn(viewController: self, withTitle: "Sorry", andMessage: "Try to solve it by yourself next time", andActionTitle: "Ok", andComplitionCode: true)
                return
            }
            
            let worngTiles = self.game.checkSln(self.puzzle)
            
            if worngTiles.count == 0 {
                Utilities.showMessageIn(viewController: self, withTitle: "Yay!!!", andMessage: "Congrats... You solved it with score: ", andActionTitle: "Ok", andComplitionCode: true)
            } else {
                showWorngTiles(worngTiles)
                Utilities.showMessageIn(viewController: self, withTitle: "Wrong answer", andMessage: "Great work, but check your answer again", andActionTitle: "Ok", andComplitionCode: false)
            }
        } else {
            return
        }
    }
    
    func boardHaveEmptyTiles(_ board: Array<Array<Int>>) -> Bool{
        for row in board {
            for cell in row {
                if cell == 0 {
                    return true;
                }
            }
        }
        return false;
    }
    
    func showWorngTiles(_ worngTiles: Array<(i:Int, j:Int)>) {
        for idx in worngTiles {
            var location = idx.i * 9
            location = location + idx.j
            
            self.tilesLabelCollection[location].textColor = UIColor.yellow
        }
    }
    //-----------------------------------------------------------------------------------------------------------
    
    
    //For Solving grid
    //-----------------
    @IBAction func solvePressed(_ sender: AnyObject) {
        madeAppSolvePuzzle = true
        
        if self.gameLevel == 0 {
            if self.puzzle.count == 0 {
                self.puzzle = Array(repeating: Array<Int>(repeating: 0, count: 9), count: 9)
            }
            self.game.solve = self.puzzle
            
            if self.game.SolveSudoku(0, col: 0) {
                self.puzzle = self.game.solve
                fillGrid()
            } else {
                Utilities.showMessageIn(viewController: self, withTitle: "Check", andMessage: "Check your tiles again because this grid has no solution", andActionTitle: "Ok", andComplitionCode: false)
            }
        } else {
            self.puzzle = self.game.answer
            fillGrid()
        }
    }
    
    func fillGrid() {
        var idx = 0
        
        for i in 0 ..< self.puzzle.count {
            for j in 0 ..< self.puzzle[i].count {
                if self.tilesLabelCollection[idx].text == "" {
                    self.tilesLabelCollection[idx].text = LanguageHandler.sharedInstance.stringForKey(key: "\(self.puzzle[i][j])")//"\(self.puzzle[i][j])"
                    self.tilesLabelCollection[idx].textColor = UIColor.white
                }
                idx += 1
            }
        }
    }
    //-----------------------------------------------------------------------------------------------------------
    
    
    //For iAds
    //---------
    /*
    func bannerViewActionShouldBegin(_ banner: ADBannerView, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.banner.isHidden = false
    }
    */
    //-----------------------------------------------------------------------------------------------------------
}
