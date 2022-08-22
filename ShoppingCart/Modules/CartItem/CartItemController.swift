//
//  CartItemController.swift
//  ShoppingCart
//
//  Created by ebpearls on 22/08/2022.
//

import UIKit
import Combine

final class CartItemController: UIViewController {
    
    var presenter: CartItemPresentable!
    
    var alertCancellable: AnyCancellable?
    
    private lazy var updateStack: UIStackView = {
       let stackView = UIFactory.stackView(axis: .horizontal)
        stackView.backgroundColor = UIColor(named: "AppGray")
        stackView.layer.cornerRadius = 15
        stackView.distribution = .equalCentering
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        return stackView
    }()
    lazy var deductButton = UIFactory.imageButton(image: .minus, tintColor: .red)
    lazy var addButton = UIFactory.imageButton(image: .plus, fill: true, tintColor: .green)
    lazy var quantityLabel = UIFactory.label(text: "\(presenter.getItemObject().quantity)")
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "AppGray")
        title = "Product Detail"
        setupButtons()
        addViews()
    }
    
    private func setupButtons() {
        let leftBarButton = UIBarButtonItem(image: .chevronLeft, style: .plain, target: self, action: #selector(leftBarButtonClicked))
        leftBarButton.tintColor = .black
        navigationItem.leftBarButtonItem = leftBarButton
        
        let rightBarButton = UIBarButtonItem(image: .delete, style: .plain, target: self, action: #selector(rightBarButtonClicked))
        rightBarButton.tintColor = .red
        navigationItem.rightBarButtonItem = rightBarButton
        
        addButton.addTarget(self, action:  #selector(addButtonClicked), for: .touchUpInside)
        deductButton.addTarget(self, action:  #selector(minusButtonClicked), for: .touchUpInside)
    }
    
    @objc private func leftBarButtonClicked() {
        presenter.goBack()
    }
    
    @objc private func rightBarButtonClicked() {
        presenter.deleteItem()
    }
    
    @objc private func addButtonClicked() {
        presenter.updateQuantity(increase: true)
    }
    
    @objc private func minusButtonClicked() {
        presenter.updateQuantity(increase: false)
    }
    
    private func addViews() {
        
        let itemImageView = UIFactory.imageView(image: presenter.getItemImage(), contentMode: .scaleAspectFill)
        itemImageView.maskTop(40)
        
        let mainVerticalContainerStack = UIView()
        mainVerticalContainerStack.backgroundColor = .white
        mainVerticalContainerStack.translatesAutoresizingMaskIntoConstraints = false
        mainVerticalContainerStack.maskTop(40)
        
        let nameAndPriceStack = UIFactory.stackView(axis: .horizontal)
        
        [itemImageView, mainVerticalContainerStack].forEach({ view.addSubview($0) })
        
        let priceLabel = UIFactory.label(font: .systemFont(ofSize: .FontSize.medium.value), textColor: .white, text: "     $\(presenter.getItemObject().price)     ", tAMIC: true)
        priceLabel.backgroundColor = .red
        priceLabel.layer.masksToBounds = true
        priceLabel.layer.cornerRadius = 15
        
        let nameLabel = UIFactory.label(font: .systemFont(ofSize: .FontSize.medium.value, weight: .semibold), text: presenter.getItemObject().name, tAMIC: true)
        [nameLabel, priceLabel].forEach({ nameAndPriceStack.addArrangedSubview($0) })
        
        let descriptionLabel = UIFactory.label(textColor: .lightGray, text: "\(presenter.getItemObject().name) is a great product. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec pretium turpis augue, ac pulvinar urna blandit eget. Sed sed nisl.")
        [nameAndPriceStack, descriptionLabel, updateStack, ].forEach({ mainVerticalContainerStack.addSubview($0) })
        
        [deductButton, quantityLabel, addButton].forEach({ updateStack.addArrangedSubview($0)})
        
        NSLayoutConstraint.activate([
        
            itemImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            itemImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            itemImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            itemImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            mainVerticalContainerStack.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: -50),
            mainVerticalContainerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mainVerticalContainerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mainVerticalContainerStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            nameAndPriceStack.topAnchor.constraint(equalTo: mainVerticalContainerStack.topAnchor, constant: 50),
            nameAndPriceStack.trailingAnchor.constraint(equalTo: mainVerticalContainerStack.trailingAnchor, constant: -20),
            nameAndPriceStack.leadingAnchor.constraint(equalTo: mainVerticalContainerStack.leadingAnchor, constant: 20),
            nameAndPriceStack.heightAnchor.constraint(equalToConstant: 50),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameAndPriceStack.bottomAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: mainVerticalContainerStack.trailingAnchor, constant: -20),
            descriptionLabel.leadingAnchor.constraint(equalTo: mainVerticalContainerStack.leadingAnchor, constant: 20),
            
            updateStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            updateStack.trailingAnchor.constraint(equalTo: mainVerticalContainerStack.trailingAnchor, constant: -20),
            updateStack.widthAnchor.constraint(equalToConstant: 150),
            updateStack.heightAnchor.constraint(equalToConstant: 50),
            updateStack.bottomAnchor.constraint(equalTo: mainVerticalContainerStack.bottomAnchor, constant: -20),
            
            
        ])
        
    }
    
}

extension CartItemController: CartItemPresenterDelegate {
    
    func updateQuantity(_ value: Int16) {
        quantityLabel.text = "\(value)"
    }
    
    func showAlert(title: String, message: String, alertActions: [AlertAction]) {
        alertCancellable = alert(title: title, msg: message, actions: alertActions).sink { alert in
            alert.actionClosure?()
        }
    }
    
}
