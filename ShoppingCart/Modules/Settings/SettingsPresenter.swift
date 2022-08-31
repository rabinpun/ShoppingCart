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
    
    var image: UIImage {
        switch self {
        case .english:
            return UIImage.delete
        case .hindi:
            return UIImage.delete
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
    
    init(router: SettingsRoutable) {
        self.router = router
    }
    
    func getLanguage(index: IndexPath) -> Language {
        Language.allCases[index.row]
    }
    
    func numerOfLanguages() -> Int {
        Language.allCases.count
    }
    
    func updateLanguage(_ index: Int) {
        let selectedLanguage = Language.allCases[index]
        print(selectedLanguage.rawValue.capitalized)
    }
    
    func goBack() {
        router.popView()
    }
    
}
