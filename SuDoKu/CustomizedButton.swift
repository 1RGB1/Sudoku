//
//  CustomizedButton.swift
//  SuDoKu
//
//  Created by Ahmad Ragab on 6/1/18.
//  Copyright © 2018 Ahmad Ragab. All rights reserved.
//

import UIKit

class CustomizedButton: UIButton {
    @IBInspectable var txt : String = "" {
        didSet {
            self.setTitle(LanguageHandler.sharedInstance.stringForKey(key: txt), for: .normal)
        }
    }
}
