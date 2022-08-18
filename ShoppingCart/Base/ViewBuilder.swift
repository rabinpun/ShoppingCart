//
//  ViewBuilder.swift
//  ShoppingCart
//
//  Created by ebpearls on 18/08/2022.
//

import UIKit

protocol ViewBuilder {
    
    associatedtype ViewType: UIViewController
    
    func build() -> ViewType
    func buildWithNavigationController() -> NavigationController
}

extension ViewBuilder {
    
    func buildWithNavigationController() -> NavigationController {
        NavigationController(appearance: .getAppNavigationBarAppearance(), rootController: build())
    }
}
