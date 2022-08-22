//
//  CartItemController.swift
//  ShoppingCart
//
//  Created by ebpearls on 22/08/2022.
//

import UIKit

final class CartItemController: UIViewController {
    
    var presenter: CartItemPresentable!
    
    override func viewDidLoad() {
        view.backgroundColor = .blue
    }
    
}

extension CartItemController: CartItemPresenterDelegate {
    
    func showAlert(title: String, message: String, alertActions: [AlertAction]) {
        
    }
    
}
