//
//  CartListRouter.swift
//  ShoppingCart
//
//  Created by ebpearls on 18/08/2022.
//

import UIKit

/// Protocol for cartlist router
protocol CartListRoutable {
    func pushDetailView(with cartItem: CartItem.Object)
}

/// Router for cartlist
struct CartListRouter: CartListRoutable {
    
    init(performer: CartListController) {
        self.performer = performer
    }
    
    func pushDetailView(with cartItem: CartItem.Object) {
    }
    
    // MARK: private
    
    private weak var performer: CartListController!
}
