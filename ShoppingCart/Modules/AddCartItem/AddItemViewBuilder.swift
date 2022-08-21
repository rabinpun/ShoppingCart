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
    
    init(database: StorageProvider, imageManager: ImageManagable) {
        self.database = database
        self.imageManager = imageManager
    }

    /// builds ViewController and injects dependency of components.
    func build() -> AddItemController {
        
        let vc = AddItemController()
        
        /// presenter dependencies
        let router =  AddItemRouter(performer: vc)
        let localRepository = LocalRepository<CartItem>(storageProvider: database)
        let addCartItemUseCase = AddCartItemUseCase(localCartItemRepository: localRepository)
        
        let presenter = AddItemPresenter(addCartItemUseCase: addCartItemUseCase, router: router, imageManager: imageManager)
        presenter.delegate = vc
        vc.presenter = presenter
        return vc
    }
}
