//
//  SettingsViewBuilder.swift
//  ShoppingCart
//
//  Created by ebpearls on 31/08/2022.
//

import UIKit

// The builder of CartItem Module
struct SettingsViewBuilder: ViewBuilder {

    /// builds ViewController and injects dependency of components.
    func build() -> SettingsController {
        
        let vc = SettingsController()
        
        /// presenter dependencies
        let router =  SettingsRouter(performer: vc)
        
        let presenter = SettingsPresenter(router: router)
        presenter.delegate = vc
        vc.presenter = presenter
        return vc
    }
}
