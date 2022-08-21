//
//  CartListViewBuilder.swift
//  ShoppingCart
//
//  Created by ebpearls on 19/08/2022.
//

import Foundation

/// The builder of CartList Module
struct CartListViewBuilder: ViewBuilder {
    
    private let database: StorageProvider
    
    init(database: StorageProvider) {
        self.database = database
    }

    /// builds ViewController and injects dependency of components.
    func build() -> CartListController {
        
        let vc = CartListController()
        
        /// presenter dependencies
        let router =  CartListRouter(performer: vc)
        let localRepository = LocalRepository<CartItem>(storageProvider: database)
        let updateCartItemUsecase = UpdateCartItemUseCase(localCartItemRepository: localRepository)
        
        let presenter = CartListPresenter(
            router: router,
            updatecartItemUseCase: updateCartItemUsecase,
            database: database)
        presenter.delegate = vc
        vc.presenter = presenter
        return vc
    }
}
