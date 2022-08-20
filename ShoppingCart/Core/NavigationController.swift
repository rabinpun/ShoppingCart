//
//  NavigationController.swift
//  ShoppingCart
//
//  Created by ebpearls on 18/08/2022.
//

import UIKit

/// NavigationController
class NavigationController: UINavigationController {
    
    public init(appearance: UINavigationBarAppearance, rootController: UIViewController) {
        UINavigationBar.appearance().standardAppearance = appearance
        super.init(rootViewController: rootController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This class is not meant to be initialized by coder")
    }
    
}
