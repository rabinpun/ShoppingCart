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
        window!.rootViewController = CartListViewBuilder(database: database).buildWithNavigationController(deepLink: nil)
        window!.makeKeyAndVisible()
    }

}

extension SceneDelegate {
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let firstUrl = URLContexts.first?.url else { return }
        if let view = firstUrl.host {
            var parameters: [String: String] = [:]
            URLComponents(url: firstUrl, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
                parameters[$0.name] = $0.value
            }
            switch view {
            case "addItem":
                if let name = parameters["name"], let image = parameters["image"], let price = parameters["price"], let tax = parameters["tax"], let quantity = parameters["quantity"] {
                    let object = CartItem.Object(id: "", name: name, image: image, tax: Float(tax) ?? 0, quantity: Int16(quantity) ?? 0, price: Float(price) ?? 0, updatedAt: Date())
                    window!.rootViewController = CartListViewBuilder(database: database).buildWithNavigationController(deepLink: .addItem(object))
                }
            default:
                break
            }
        }
    }
}

//shoppingcart://addItem?name=Pizza&&image=pizza&&tax=15&&quantity=10&&price=400
