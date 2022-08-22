//
//  UIView.swift
//  ShoppingCart
//
//  Created by ebpearls on 22/08/2022.
//

import UIKit

extension UIView {
    
    func maskTop(_ cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
}
