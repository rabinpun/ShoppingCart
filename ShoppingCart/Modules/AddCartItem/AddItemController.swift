//
//  AddItemController.swift
//  ShoppingCart
//
//  Created by ebpearls on 21/08/2022.
//

import UIKit

final class AddItemController: UIViewController {
    
    var presenter: AddItemPresentable!
    
    override func viewDidLoad() {
        view.backgroundColor = .blue
    }
}

extension AddItemController: AddItemPresenterDelegate {
    func showAlert(title: String, message: String, alertActions: [AlertAction]) {
    
    }
    
}
