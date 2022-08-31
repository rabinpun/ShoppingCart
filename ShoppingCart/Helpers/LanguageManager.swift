//
//  LanguageManager.swift
//  ShoppingCart
//
//  Created by ebpearls on 31/08/2022.
//

import Foundation
import Combine

protocol LanguageManagable {
    var selectedLanguage: PassthroughSubject<Language,Never> { get }
    func selectLanguage(_ language: Language)
}

final class LanguageManager: LanguageManagable {
    
    static var currentLanguage: Language {
        get {
            let languageRawValue = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "english"
            return Language(rawValue: languageRawValue)!
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedLanguage")
        }
    }
    
    let selectedLanguage = PassthroughSubject<Language,Never>()
    
    func selectLanguage(_ language: Language) {
        LanguageManager.currentLanguage = language
        selectedLanguage.send(language)
    }
    
}
