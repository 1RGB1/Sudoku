//
//  HomeViewController.swift
//  SuDoKu
//
//  Created by Ahmad Ragab on 12/27/15.
//  Copyright © 2015 Ahmad Ragab. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController
{
    var gameLeve = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func GameLevelPressed(_ sender: UIButton) {
        self.gameLeve = sender.tag;
        self.performSegue(withIdentifier: "startGameSegue", sender: self);
    }
    
    @IBAction func changeLangPressed(_ sender: Any) {
        if LanguageHandler.sharedInstance.currentLanguage == .ENGLISH {
            LanguageHandler.sharedInstance.setDirection(.RTL, andLanguage: .ARABIC)
        } else {
            LanguageHandler.sharedInstance.setDirection(.LTR, andLanguage: .ENGLISH)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let SBVC = segue.destination as! SudokuBoardViewController
        SBVC.gameLevel = self.gameLeve
        SBVC.generateGame()
    }
}

