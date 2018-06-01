//
//  Utilities.swift
//  SuDoKu
//
//  Created by Ahmad Ragab on 6/1/18.
//  Copyright © 2018 Ahmad Ragab. All rights reserved.
//

import UIKit

class Utilities {
    class func showMessageIn(viewController: UIViewController, withTitle title: String, andMessage message: String, andActionTitle actionTitle: String, andComplitionCode complitionCode: Bool) {
        
        let titleStr = LanguageHandler.sharedInstance.stringForKey(key: title)
        let msg = LanguageHandler.sharedInstance.stringForKey(key: message)
        let actionTitleStr = LanguageHandler.sharedInstance.stringForKey(key: actionTitle)
        
        let messageC = UIAlertController(title: titleStr, message: msg, preferredStyle: .alert)
        let okAction : UIAlertAction!
        
        if complitionCode {
            okAction = UIAlertAction(title: actionTitleStr, style: .default, handler: { (okAction) -> Void in
                viewController.dismiss(animated: true, completion: nil);
            })
        } else {
            okAction = UIAlertAction(title: actionTitleStr, style: .default, handler: nil)
        }
        
        messageC.addAction(okAction)
        viewController.present(messageC, animated: true, completion: nil)
    }
}
