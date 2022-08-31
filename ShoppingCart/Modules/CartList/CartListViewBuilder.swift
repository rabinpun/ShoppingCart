//
//  CartListViewBuilder.swift
//  ShoppingCart
//
//  Created by ebpearls on 19/08/2022.
//

import Foundation

enum DeepLink {
    case addItem(CartItem.Object)
}

/// The builder of CartList Module
struct CartListViewBuilder: ViewBuilder {
    
    private let database: StorageProvider
    
    init(database: StorageProvider) {
        self.database = database
    }

    /// builds ViewController and injects dependency of components.
    func build(deepLink: DeepLink?) -> CartListController {
        
        let vc = CartListController()
        
        /// presenter dependencies
        let router =  CartListRouter(performer: vc, deepLink: deepLink)
        let localRepository = LocalRepository<CartItem>(storageProvider: database)
        let updateCartItemUsecase = UpdateCartItemUseCase(localCartItemRepository: localRepository)
        let imageManager = ImageManager()
        let languageManager = LanguageManager()
        
        let presenter = CartListPresenter(
            router: router,
            updatecartItemUseCase: updateCartItemUsecase,
            database: database,
            imageManager: imageManager,
            languageManager: languageManager
        )
        presenter.delegate = vc
        vc.presenter = presenter
        return vc
    }
}
