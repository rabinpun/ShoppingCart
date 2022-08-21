//
//  CartListRouter.swift
//  ShoppingCart
//
//  Created by ebpearls on 18/08/2022.
//

import UIKit

/// Protocol for cartlist router
protocol CartListRoutable {
    func presentAddItemView(with database: StorageProvider)
    func pushDetailView(with cartItem: CartItem.Object)
}

/// Router for cartlist
struct CartListRouter: CartListRoutable {
    
    private weak var performer: CartListController!
    
    init(performer: CartListController) {
        self.performer = performer
    }
    
    func pushDetailView(with cartItem: CartItem.Object) {
    }
    
    func presentAddItemView(with database: StorageProvider) {
        let vc = AddItemViewBuilder(database: database).build()
        self.performer.present(vc, animated: true)
    }
    
}
