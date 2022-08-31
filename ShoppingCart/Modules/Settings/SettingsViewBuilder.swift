//
//  SettingsViewBuilder.swift
//  ShoppingCart
//
//  Created by ebpearls on 31/08/2022.
//

import UIKit

// The builder of CartItem Module
struct SettingsViewBuilder: ViewBuilder {
    
    private let languageManager: LanguageManagable
    
    init(languageManager: LanguageManagable) {
        self.languageManager = languageManager
    }

    /// builds ViewController and injects dependency of components.
    func build() -> SettingsController {
        
        let vc = SettingsController()
        
        /// presenter dependencies
        let router =  SettingsRouter(performer: vc)
        
        let presenter = SettingsPresenter(router: router, languageManager: languageManager)
        presenter.delegate = vc
        vc.presenter = presenter
        return vc
    }
}
