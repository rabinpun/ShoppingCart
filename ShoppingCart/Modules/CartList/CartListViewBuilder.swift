//
//  CartListViewBuilder.swift
//  ShoppingCart
//
//  Created by ebpearls on 19/08/2022.
//

import Foundation

/// The builder of CartListViewBuilder
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
        let localCartItemRepository = LocalRepository<CartItem>(storageProvider: database)
        let dbContext = database.getBgContext()
        
        let presenter = CartListPresenter(
            router: router,
            localCartItemRepository: localCartItemRepository,
            dbContext: dbContext)
        presenter.delegate = vc
        vc.presenter = presenter
        return vc
    }
}
