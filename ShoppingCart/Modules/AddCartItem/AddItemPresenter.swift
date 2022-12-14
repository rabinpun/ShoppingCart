//
//  AddItemPresenter.swift
//  ShoppingCart
//
//  Created by ebpearls on 21/08/2022.
//

import UIKit

/// Protocol for AddItem Presenter delegate
protocol AddItemPresenterDelegate: UIViewController {
    func populateUI(with object: CartItem.Object)
    func showAlert(title: String, message: String, alertActions: [AlertAction])
}

/// Protocol for AddItem presenter
protocol AddItemPresentable {
    var delegate: AddItemPresenterDelegate? { get set }
    
    func addItem(parameters: [(ParameterType,String)])
    func addImage(_ image: UIImage?)
    func imageFor(_ name: String) -> UIImage?
    func setUp()
}

enum ParameterType: String {
    case name, tax, price, quantity, image
}

enum AddItemError: LocalizedError {
    case empty(ParameterType), invalid(ParameterType)
    
    var errorDescription: String? {
        switch self {
        case .empty(let parameterType):
            return LocalizedKey.isEmpty(parameterType.rawValue).value
        case .invalid(let parameterType):
            return LocalizedKey.isInvalid(parameterType.rawValue).value
        }
    }
}

final class AddItemPresenter: AddItemPresentable {

    weak var delegate: AddItemPresenterDelegate?
    
    private let router: AddItemRoutable
    private let addCartItemUseCase: AddCartItemUseCase
    private var image: UIImage?
    private let imageManager: ImageManagable
    
    init(addCartItemUseCase: AddCartItemUseCase, router: AddItemRoutable, imageManager: ImageManagable) {
        self.addCartItemUseCase = addCartItemUseCase
        self.router = router
        self.imageManager = imageManager
        
    }
    
    func setUp() {
        router.handleDeepLink { deepLink in
            if let deepLink = deepLink {
                switch deepLink {
                case .addItem(let cartItem):
                    delegate?.populateUI(with: cartItem)
                }
            }
        }
    }
    
    func addItem(parameters: [(ParameterType,String)]) {
        do {
            try createItem(parameters)
        } catch {
            delegate?.showAlert(title: LocalizedKey.error.value, message: error.localizedDescription, alertActions: [AlertAction.ok(nil)])
        }
    }
    
    private func createItem(_ parameters: [(ParameterType,String)]) throws {
        for parameter in parameters {
            if parameter.1.isEmpty {
                throw AddItemError.empty(ParameterType(rawValue: parameter.0.rawValue)!)
            } else {
                switch parameter.0 {
                case .tax:
                    if Float(parameter.1) == nil {
                        throw AddItemError.invalid(ParameterType(rawValue: parameter.0.rawValue)!)
                    }
                case .price:
                    if Float(parameter.1) == nil {
                        throw AddItemError.invalid(ParameterType(rawValue: parameter.0.rawValue)!)
                    }
                case .quantity:
                    if Int16(parameter.1) == nil {
                        throw AddItemError.invalid(ParameterType(rawValue: parameter.0.rawValue)!)
                    }
                default:
                    break
                }
            }
        }
        
        let id =  UUID().uuidString
        if let image = image {
            do {
                let imageName = id + ".jpg"
                try imageManager.saveImage(image, name: imageName)
                addCartItemUseCase.create(CartItem.Object(id: id, name: parameters[0].1, image: imageName, tax: Float(parameters[3].1)!, quantity: Int16(parameters[2].1)!, price: Float(parameters[1].1)!, updatedAt: Date()))
            } catch {
                addCartItemUseCase.create(CartItem.Object(id: id, name: parameters[0].1, image: nil, tax: Float(parameters[3].1)!, quantity: Int16(parameters[2].1)!, price: Float(parameters[1].1)!, updatedAt: Date()))
            }
        } else {
            addCartItemUseCase.create(CartItem.Object(id: id, name: parameters[0].1, image: nil, tax: Float(parameters[3].1)!, quantity: Int16(parameters[2].1)!, price: Float(parameters[1].1)!, updatedAt: Date()))
        }
        router.dismissView()
    }
    
    func addImage(_ image: UIImage?) {
        self.image = image
    }
    
    func imageFor(_ name: String) -> UIImage? {
        try? imageManager.getImage(name: name)
    }
    
}
