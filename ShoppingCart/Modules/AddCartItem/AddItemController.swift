//
//  AddItemController.swift
//  ShoppingCart
//
//  Created by ebpearls on 21/08/2022.
//

import UIKit
import Combine

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
    
    ///Constraints
    private let buttonHeight: CGFloat = 40
    
    var presenter: AddItemPresentable!
    
    private let textFields = TextFieldType.allCases
    
    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIFactory.stackView(axis: .vertical)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel = UIFactory.label(font: .systemFont(ofSize: .FontSize.medium.rawValue, weight: .semibold), textColor: .white, text: "Add product to the cart")
    private lazy var createButton = UIFactory.textButton(text: "Create item", cornerRadius: buttonHeight * 0.25)
    
    private var alertCancellable: AnyCancellable?
    
    override func viewDidLoad() {
        view.backgroundColor = .systemTeal
        
        addViews()
        createButton.addTarget(self, action: #selector(createButtonClicked), for: .touchUpInside)
    }
    
    private func addViews() {
        
        [titleLabel, textFieldStackView, createButton].forEach({ view.addSubview($0) })
        
        textFields.forEach { textField in
            let stackView = UIFactory.stackView(axis: .vertical, spacing: 10)
            let label = UIFactory.label(font: .systemFont(ofSize: .FontSize.regular.value, weight: .semibold),text: textField.title)
            label.translatesAutoresizingMaskIntoConstraints = true
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(UIFactory.textField(placeholder: textField.placeholder, keyBoardType: textField.keyboardType))
            
            textFieldStackView.addArrangedSubview(stackView)
        }
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            
            textFieldStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            textFieldStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            textFieldStackView.heightAnchor.constraint(equalToConstant: 300),
            
            createButton.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 30),
            createButton.centerXAnchor.constraint(equalTo: textFieldStackView.centerXAnchor),
            createButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            createButton.widthAnchor.constraint(equalToConstant: 120),
                
        ])
        
    }
    
    @objc private func createButtonClicked() {
        let stackViews = textFieldStackView.arrangedSubviews as! [UIStackView]
        let textFields = stackViews.reduce([Textfield](), { $0 + $1.arrangedSubviews.filter({ $0 is Textfield }) as! [Textfield] })
        let parameters: [(ParameterType,String)] = [
            (.name, textFields[0].text ?? ""),
            (.price, textFields[1].text ?? ""),
            (.quantity, textFields[2].text ?? ""),
            (.tax, textFields[3].text ?? ""),
        ]
//        presenter.addItem(parameters: parameters)
        showActionSheetForImageSelection()
    }
    
}

extension AddItemController: AddItemPresenterDelegate {
    func showAlert(title: String, message: String, alertActions: [AlertAction]) {
        alertCancellable = alert(title: title, msg: message, actions: alertActions).sink { alert in
            alert.actionClosure?()
        }
    }
    
    private func showActionSheetForImageSelection() {
        alertCancellable = alert(actions: [.takePhoto(nil), .openGallery(nil), .cancel], style: .actionSheet).sink { alert in
            alert.actionClosure?()
        }
    }
    
    private func showCameraPermissionAlert() {
        func openSettings() {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertCancellable = alert(title: "Shopping Cart", msg: "Please allow camera access...", actions: [.setting(openSettings), .cancel]).sink { alert in
            alert.actionClosure?()
        }
    }
    
}
