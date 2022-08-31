//
//  SettingsRouter.swift
//  ShoppingCart
//
//  Created by ebpearls on 31/08/2022.
//

import UIKit

/// Protocol for cartlist router
protocol SettingsRoutable {
    func popView()
}

/// Router for cartlist
struct SettingsRouter: SettingsRoutable {
    
    private weak var performer: SettingsController!
    
    init(performer: SettingsController) {
        self.performer = performer
    }
    
    func popView() {
        self.performer.navigationController?.popViewController(animated: true)
    }
}
