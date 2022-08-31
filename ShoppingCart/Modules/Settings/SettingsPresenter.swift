//
//  SettingsPresenter.swift
//  ShoppingCart
//
//  Created by ebpearls on 31/08/2022.
//

import Foundation
import UIKit

enum Language: String, CaseIterable {
    case english, hindi
    
    var title: String {
        switch self {
        case .english:
            return LocalizedKey.english.value
        case .hindi:
            return LocalizedKey.hindi.value
        }
    }
    
    var image: UIImage {
        switch self {
        case .english:
            return UIImage.flagImage(name: "us")
        case .hindi:
            return UIImage.flagImage(name: "in")
        }
    }
}

protocol SettingsPresentable: AnyObject {
    
    var delegate: SettingsPresenterDelegate? { get set }
    
    func getLanguage(index: IndexPath) -> Language
    func numerOfLanguages() -> Int
    func updateLanguage(_ index: Int)
    func goBack()
}

protocol SettingsPresenterDelegate: UIViewController {
    func showAlert(title: String, message: String, alertActions: [AlertAction])
}

final class SettingsPresenter: NSObject, SettingsPresentable {
    
    
    weak var delegate: SettingsPresenterDelegate?
    let router: SettingsRoutable
    let languageManager: LanguageManagable
    
    init(router: SettingsRoutable, languageManager: LanguageManagable) {
        self.router = router
        self.languageManager = languageManager
    }
    
    func getLanguage(index: IndexPath) -> Language {
        Language.allCases[index.row]
    }
    
    func numerOfLanguages() -> Int {
        Language.allCases.count
    }
    
    func updateLanguage(_ index: Int) {
        let selectedLanguage = Language.allCases[index]
        func selectLanguage() {
            languageManager.selectLanguage(selectedLanguage)
            goBack()
        }
        delegate?.showAlert(title: LocalizedKey.appName.value, message: LocalizedKey.selectLanguageMessage(selectedLanguage.title).value, alertActions: [.ok(selectLanguage), .cancel])
    }
    
    func goBack() {
        router.popView()
    }
    
}
