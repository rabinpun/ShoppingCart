//
//  SceneDelegate.swift
//  ShoppingCart
//
//  Created by ebpearls on 17/08/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var database: StorageProvider = {
        Database(modalName: "ShoppingCart")
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = scene as? UIWindowScene else { return }
        setupInitalView(windowScens: windowScene)
    }
    
    private func setupInitalView (windowScens: UIWindowScene) {
        window = UIWindow(windowScene: windowScens)
        let deepLink = DeepLink.addItem(CartItem.Object(id: "", name: "Pizza", image: "pizza", tax: 15, quantity: 10, price: 400, updatedAt: Date()))
        window!.rootViewController = CartListViewBuilder(database: database).buildWithNavigationController(deepLink: deepLink)
        window!.makeKeyAndVisible()
    }

}

