//
//  CartListRouter.swift
//  ShoppingCart
//
//  Created by ebpearls on 18/08/2022.
//

import UIKit

protocol DeepLinkHandler {
    func handleDeepLink(handler: (DeepLink?) -> Void)
}

/// Protocol for cartlist router
protocol CartListRoutable: DeepLinkHandler {
    func presentAddItemView(with database: StorageProvider, imageManager: ImageManagable)
    func pushDetailView(with cartItem: CartItem.Object, image: UIImage, updateItemUseCase: UpdateCartItemUseCase)
    func pushDetailSettingsView(languageManger: LanguageManagable)
}

/// Router for cartlist
struct CartListRouter: CartListRoutable {

    private weak var performer: CartListController!
    private var deepLink: DeepLink?
    
    init(performer: CartListController, deepLink: DeepLink?) {
        self.performer = performer
        self.deepLink = deepLink
    }
    
    func handleDeepLink(handler: (DeepLink?) -> Void) {
        handler(deepLink)
    }
    
    func pushDetailView(with cartItem: CartItem.Object, image: UIImage, updateItemUseCase: UpdateCartItemUseCase) {
        let vc = CartItemViewBuilder(updatecartItemUseCase: updateItemUseCase, productModel: cartItem, image: image).build(deepLink: deepLink)
        self.performer.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentAddItemView(with database: StorageProvider, imageManager: ImageManagable) {
        let vc = AddItemViewBuilder(database: database, imageManager: imageManager, deepLink: deepLink).build(deepLink: deepLink)
        self.performer.present(vc, animated: true)
    }
    
    func pushDetailSettingsView(languageManger: LanguageManagable) {
        let vc = SettingsViewBuilder(languageManager: languageManger).build(deepLink: deepLink)
        self.performer.navigationController?.pushViewController(vc, animated: true)
    }
    
}
