//
//  UINavigationBarAppearance.swift
//  ShoppingCart
//
//  Created by ebpearls on 18/08/2022.
//

import UIKit

extension UINavigationBarAppearance {
    
    static func getAppNavigationBarAppearance() -> UINavigationBarAppearance {
        
        let largeFont = UIFont.systemFont(ofSize: .FontSize.large.value)
        let smallFont = UIFont.systemFont(ofSize: .FontSize.medium.value)

        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font: smallFont]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black, .font: largeFont]
        return navigationBarAppearance
    }
    
}
