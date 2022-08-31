//
//  AddItemRouter.swift
//  ShoppingCart
//
//  Created by ebpearls on 21/08/2022.
//

import UIKit

/// Protocol for cartlist router
protocol AddItemRoutable: DeepLinkHandler {
    func dismissView()
}

/// Router for cartlist
struct AddItemRouter: AddItemRoutable {
    
    private weak var performer: AddItemController!
    private var deepLink: DeepLink?
    
    init(performer: AddItemController,deepLink: DeepLink?) {
        self.performer = performer
        self.deepLink = deepLink
    }
    
    func handleDeepLink(handler: (DeepLink?) -> Void) {
        handler(deepLink)
    }
    
    func dismissView() {
        self.performer.dismiss(animated: true)
    }
}
