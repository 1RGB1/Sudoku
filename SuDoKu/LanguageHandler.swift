//
//  LanguageHandler.swift
//  SuDoKu
//
//  Created by Ahmad Ragab on 6/1/18.
//  Copyright © 2018 Ahmad Ragab. All rights reserved.
//

import Foundation

enum LanguageType : Int {
    case ENGLISH = 1
    case ARABIC = 2
}

enum LanguageShortcut : String {
    case EN = "en"
    case AR = "ar-EG"
}

enum DirectionType : Int {
    case LTR = 1
    case RTL = 2
}


class LanguageHandler {
    static let sharedInstance = LanguageHandler()
    var currentLanguage : LanguageType = .ENGLISH
    var currentDirection : DirectionType = .LTR
    var defaults : UserDefaults?
    
    private init() {
        defaults = UserDefaults.standard
        let language = defaults!.integer(forKey: "language")
        
        if language == 0 {
            self.setDefaultAppSettings()
        } else {
            let direction = defaults!.integer(forKey: "direction")
            self.setDirection(DirectionType(rawValue: direction) ?? .LTR, andLanguage: LanguageType(rawValue: language) ?? .ENGLISH)
        }
    }
    
    private func setDefaultAppSettings() {
        let language : String = Locale.preferredLanguages.first ?? "en"
        
        if language == "en" {
            self.setDirection(.LTR, andLanguage: .ENGLISH)
        } else {
            self.setDirection(.RTL, andLanguage: .ARABIC)
        }
    }
    
    func setDirection(_ direction: DirectionType, andLanguage language: LanguageType) {
        self.setCurrentDirection(direction: direction)
        self.setCurrentLanguage(language: language)
    }
    
    private func setCurrentLanguage(language: LanguageType) {
        if currentLanguage != language || defaults == nil {
            defaults = UserDefaults.standard
            defaults?.set(language.rawValue, forKey: "language")
            defaults?.synchronize()
            currentLanguage = language
        }
    }
    
    private func setCurrentDirection(direction: DirectionType) {
        if currentDirection != direction || defaults == nil {
            defaults = UserDefaults.standard
            defaults?.set(direction.rawValue, forKey: "direction")
            defaults?.synchronize()
            currentDirection = direction
        }
    }

    func stringForKey(key: String) -> String {
        
        var resource : String = ""
        
        if currentLanguage == .ENGLISH {
            resource = LanguageShortcut.EN.rawValue
        } else {
            resource = LanguageShortcut.AR.rawValue
        }
        
        let path = Bundle.main.path(forResource: resource, ofType: "lproj")
        let bundle = Bundle.init(path: path!)! as Bundle
        
        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }
}
