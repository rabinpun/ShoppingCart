//
//  AddItemRouter.swift
//  ShoppingCart
//
//  Created by ebpearls on 21/08/2022.
//

import UIKit

/// Protocol for cartlist router
protocol AddItemRoutable {
    func dismissView()
}

/// Router for cartlist
struct AddItemRouter: AddItemRoutable {
    
    private weak var performer: AddItemController!
    
    init(performer: AddItemController) {
        self.performer = performer
    }
    
    func dismissView() {
        self.performer.dismiss(animated: true)
    }
}
