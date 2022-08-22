//
//  CartListRouter.swift
//  ShoppingCart
//
//  Created by ebpearls on 18/08/2022.
//

import UIKit

/// Protocol for cartlist router
protocol CartListRoutable {
    func presentAddItemView(with database: StorageProvider, imageManager: ImageManagable)
    func pushDetailView(with cartItem: CartItem.Object, image: UIImage, updateItemUseCase: UpdateCartItemUseCase)
}

/// Router for cartlist
struct CartListRouter: CartListRoutable {
    
    private weak var performer: CartListController!
    
    init(performer: CartListController) {
        self.performer = performer
    }
    
    func pushDetailView(with cartItem: CartItem.Object, image: UIImage, updateItemUseCase: UpdateCartItemUseCase) {
        let vc = CartItemViewBuilder(updatecartItemUseCase: updateItemUseCase, productModel: cartItem, image: image).build()
        self.performer.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentAddItemView(with database: StorageProvider, imageManager: ImageManagable) {
        let vc = AddItemViewBuilder(database: database, imageManager: imageManager).build()
        self.performer.present(vc, animated: true)
    }
    
}
