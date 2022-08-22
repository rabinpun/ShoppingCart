//
//  CartItemPresenter.swift
//  ShoppingCart
//
//  Created by ebpearls on 22/08/2022.
//

import Foundation
import UIKit

protocol CartItemPresentable: AnyObject {
    
    var delegate: CartItemPresenterDelegate? { get set }
    
    func getItemObject() -> CartItem.Object
    func getItemImage() -> UIImage
    func deleteProduct()
    func updateQuantity(increase: Bool)
}

protocol CartItemPresenterDelegate {
    func showAlert(title: String, message: String, alertActions: [AlertAction])
}

final class CartItemPresenter: NSObject, CartItemPresentable {
    
    var delegate: CartItemPresenterDelegate?
    
    private let updatecartItemUseCase: UpdateCartItemUseCase
    private let router: CartItemRouter
    private let image: UIImage
    private var productModel: CartItem.Object
    
    init(updatecartItemUseCase: UpdateCartItemUseCase, router: CartItemRouter, productModel: CartItem.Object, image: UIImage) {
        self.updatecartItemUseCase = updatecartItemUseCase
        self.router = router
        self.image = image
        self.productModel = productModel
    }
    
    func getItemObject() -> CartItem.Object {
        productModel
    }
    
    func getItemImage() -> UIImage {
        image
    }
    
    func deleteProduct() {
        updatecartItemUseCase.delete(NSPredicate(format: "%K == %@", #keyPath(CartItem.itemId), productModel.id))
    }
    
    func updateQuantity(increase: Bool) {
        var newQuantity = productModel.quantity
        newQuantity += increase ? 1 : -1
        do {
            try updateItemIfValid(quantity: newQuantity)
        } catch {
            delegate?.showAlert(title: "ShoppingCart", message: error.localizedDescription, alertActions: [.delete(deleteProduct), .cancel])
        }
    }
    
    private func updateItemIfValid(quantity: Int16) throws {
        guard quantity > 0 else { throw CartListError.quantityIsZero }
        let predicate = NSPredicate(format: "%K == %@", #keyPath(CartItem.itemId), productModel.id)
        productModel.quantity = quantity
        updatecartItemUseCase.update(predicate, productModel)
    }
    
}
