//
//  CartListHeader.swift
//  ShoppingCart
//
//  Created by ebpearls on 20/08/2022.
//

import UIKit

extension UITableViewHeaderFooterView: Identifiable {}

class CartListHeader: UITableViewHeaderFooterView {
    
    lazy var itemNameLabel: UILabel = {
        let label = UIFactory.label()
        label.numberOfLines = 1
        return label
    }()
    
    lazy var priceLabel = UIFactory.label()
    lazy var quantityLabel = UIFactory.label()
    lazy var totalAmountLabel = UIFactory.label()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(totalAmountLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// generate the child of the view
    private func generateChildrens() {
        NSLayoutConstraint.activate([
            
            
            itemNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 70),
            itemNameLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -40),
            itemNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: itemNameLabel.trailingAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: quantityLabel.leadingAnchor, constant: 10),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            
            quantityLabel.trailingAnchor.constraint(equalTo: totalAmountLabel.leadingAnchor, constant: -10),
            quantityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            quantityLabel.widthAnchor.constraint(equalToConstant: 70),
            
            totalAmountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            totalAmountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            totalAmountLabel.widthAnchor.constraint(equalToConstant: 60),
        
        ])
        
    }
    
    /// Configure the header vuew
    func configure() {
        itemNameLabel.text = "Item"
        priceLabel.text = "Price"
        quantityLabel.text = "Quantity"
        totalAmountLabel.text = "Total"
        generateChildrens()
    }
}

