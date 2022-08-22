//
//  CartItemRouter.swift
//  ShoppingCart
//
//  Created by ebpearls on 22/08/2022.
//

import UIKit

/// Protocol for cartlist router
protocol CartItemRoutable {
    func popView()
}

/// Router for cartlist
struct CartItemRouter: CartItemRoutable {
    
    private weak var performer: CartItemController!
    
    init(performer: CartItemController) {
        self.performer = performer
    }
    
    func popView() {
        self.performer.navigationController?.popViewController(animated: true)
    }
}
