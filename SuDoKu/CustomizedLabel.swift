//
//  CustomizedLabel.swift
//  SuDoKu
//
//  Created by Ahmad Ragab on 6/1/18.
//  Copyright © 2018 Ahmad Ragab. All rights reserved.
//

import UIKit

class CustomizedLabel: UILabel {
    @IBInspectable var txt : String = "" {
        didSet {
            self.text = LanguageHandler.sharedInstance.stringForKey(key: txt)
        }
    }
}
