//
//  AddItemViewBuilder.swift
//  ShoppingCart
//
//  Created by ebpearls on 21/08/2022.
//

import Foundation

// The builder of AddItem Module
struct AddItemViewBuilder: ViewBuilder {
    
    private let database: StorageProvider
    private let imageManager: ImageManagable
    private var deepLink: DeepLink?
    
    init(database: StorageProvider, imageManager: ImageManagable, deepLink: DeepLink?) {
        self.database = database
        self.imageManager = imageManager
        self.deepLink = deepLink
    }

    /// builds ViewController and injects dependency of components.
    func build(deepLink: DeepLink?) -> AddItemController {
        
        let vc = AddItemController()
        
        /// presenter dependencies
        let router =  AddItemRouter(performer: vc, deepLink: deepLink)
        let localRepository = LocalRepository<CartItem>(storageProvider: database)
        let addCartItemUseCase = AddCartItemUseCase(localCartItemRepository: localRepository)
        
        let presenter = AddItemPresenter(addCartItemUseCase: addCartItemUseCase, router: router, imageManager: imageManager)
        presenter.delegate = vc
        vc.presenter = presenter
        return vc
    }
}
