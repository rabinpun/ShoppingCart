//
//  AddItemPresenter.swift
//  ShoppingCart
//
//  Created by ebpearls on 21/08/2022.
//

import UIKit

/// Protocol for AddItem Presenter delegate
protocol AddItemPresenterDelegate: UIViewController {
    func showAlert(title: String, message: String, alertActions: [AlertAction])
}

/// Protocol for AddItem presenter
protocol AddItemPresentable {
    var delegate: AddItemPresenterDelegate? { get set }

    func addItem(name: String, image: String?, tax: Float, quantity: Int16, price: Float)
}

final class AddItemPresenter: AddItemPresentable {
    
    weak var delegate: AddItemPresenterDelegate?
    
    private let addCartItemUseCase: AddCartItemUseCase
    
    init(addCartItemUseCase: AddCartItemUseCase) {
        self.addCartItemUseCase = addCartItemUseCase
    }
    
    func addItem(name: String, image: String?, tax: Float, quantity: Int16, price: Float) {
        addCartItemUseCase.create(CartItem.Object(id: UUID().uuidString, name: name, image: image, tax: tax, quantity: quantity, price: price, updatedAt: Date()))
    }
    
}
