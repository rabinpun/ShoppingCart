//
//  ViewBuilder.swift
//  ShoppingCart
//
//  Created by rabin on 18/08/2022.
//

import UIKit

protocol ViewBuilder {
    
    associatedtype ViewType: UIViewController
    
    func build(deepLink: DeepLink?) -> ViewType
    func buildWithNavigationController(deepLink: DeepLink?) -> NavigationController
}

extension ViewBuilder {
    
    func buildWithNavigationController(deepLink: DeepLink?) -> NavigationController {
        NavigationController(appearance: .getAppNavigationBarAppearance(), rootController: build(deepLink: deepLink))
    }
}
