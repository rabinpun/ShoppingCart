//
//  CartItemViewBuilder.swift
//  ShoppingCart
//
//  Created by ebpearls on 22/08/2022.
//

import UIKit

// The builder of CartItem Module
struct CartItemViewBuilder: ViewBuilder {
    
    private let updatecartItemUseCase: UpdateCartItemUseCase
    private let productModel: CartItem.Object
    private let image: UIImage
    
    init(updatecartItemUseCase: UpdateCartItemUseCase, productModel: CartItem.Object, image: UIImage) {
        self.updatecartItemUseCase = updatecartItemUseCase
        self.productModel = productModel
        self.image = image
    }

    /// builds ViewController and injects dependency of components.
    func build() -> CartItemController {
        
        let vc = CartItemController()
        
        /// presenter dependencies
        let router =  CartItemRouter(performer: vc)
        
        let presenter = CartItemPresenter(updatecartItemUseCase: updatecartItemUseCase, router: router, productModel: productModel, image: image)
        presenter.delegate = vc
        vc.presenter = presenter
        return vc
    }
}
