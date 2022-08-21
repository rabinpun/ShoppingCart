//
//  AddItemController.swift
//  ShoppingCart
//
//  Created by ebpearls on 21/08/2022.
//

import UIKit

enum TextFieldType: CaseIterable {
    case name, price, quantity, tax
    
    var title: String {
        switch self {
        case .name:
            return "Item name:"
        case .price:
            return "Price:"
        case .quantity:
            return "Quantity:"
        case .tax:
            return "Tax:"
        }
    }
    
    var placeholder: String {
        return "Enter \(title.lowercased())..."
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .name:
            return .alphabet
        case .quantity:
            return .numberPad
        case .tax, .price:
            return .numbersAndPunctuation
        }
    }
}

final class AddItemController: UIViewController {
    
    var presenter: AddItemPresentable!
    
    private let textFields = TextFieldType.allCases
    
    lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemTeal
        
        addTextFields()
    }
    
    private func addTextFields() {
        
        view.addSubview(textFieldStackView)
        textFields.forEach { textField in
            let stackView = UIFactory.stackView()
            let label = UIFactory.label(font: .systemFont(ofSize: .FontSize.regular.value, weight: .semibold),text: textField.title)
            label.translatesAutoresizingMaskIntoConstraints = true
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(UIFactory.textField(placeholder: textField.placeholder, keyBoardType: textField.keyboardType))
            
            textFieldStackView.addArrangedSubview(stackView)
        }
        
        NSLayoutConstraint.activate([
            
            textFieldStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            textFieldStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            textFieldStackView.heightAnchor.constraint(equalToConstant: 300),
                
        ])
        
    }
    
}

extension AddItemController: AddItemPresenterDelegate {
    func showAlert(title: String, message: String, alertActions: [AlertAction]) {
    
    }
    
}
