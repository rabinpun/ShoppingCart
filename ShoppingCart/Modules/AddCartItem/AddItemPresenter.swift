//
//  AddItemPresenter.swift
//  ShoppingCart
//
//  Created by ebpearls on 21/08/2022.
//

import UIKit

/// Protocol for AddItem Presenter delegate
protocol AddItemPresenterDelegate: UIViewController {
    func showAlert(title: String, message: String, alertActions: [AlertAction])
}

/// Protocol for AddItem presenter
protocol AddItemPresentable {
    var delegate: AddItemPresenterDelegate? { get set }
    
    func addItem(parameters: [(ParameterType,String)])
}

enum ParameterType: String {
    case name, tax, price, quantity, image
}

enum AddItemError: LocalizedError {
    case empty(ParameterType), invalid(ParameterType)
    
    var errorDescription: String? {
        switch self {
        case .empty(let parameterType):
            return "\(parameterType.rawValue) is empty."
        case .invalid(let parameterType):
            return "\(parameterType.rawValue) is invalid."
        }
    }
}

final class AddItemPresenter: AddItemPresentable {
    
    weak var delegate: AddItemPresenterDelegate?
    
    private let router: AddItemRoutable
    private let addCartItemUseCase: AddCartItemUseCase
    
    init(addCartItemUseCase: AddCartItemUseCase, router: AddItemRoutable) {
        self.addCartItemUseCase = addCartItemUseCase
        self.router = router
    }
    
    func addItem(parameters: [(ParameterType,String)]) {
        do {
            try createItem(parameters)
        } catch {
            delegate?.showAlert(title: "Error", message: error.localizedDescription, alertActions: [AlertAction.ok(nil)])
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
        
        addCartItemUseCase.create(CartItem.Object(id: UUID().uuidString, name: parameters[0].1, image: nil, tax: Float(parameters[3].1)!, quantity: Int16(parameters[2].1)!, price: Float(parameters[1].1)!, updatedAt: Date()))
        router.dismissView()
    }
    
}
