//
//  CartListFooter.swift
//  ShoppingCart
//
//  Created by ebpearls on 20/08/2022.
//

import UIKit

class CartListFooter: UITableViewHeaderFooterView {
    
    lazy var grandTotalLabel: UILabel = UIFactory.label(font: .systemFont(ofSize: .FontSize.regular.value, weight: .semibold), text: "Grand Total: ")
    
    lazy var totalAmountLabel: UILabel = UIFactory.label()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        totalAmountLabel.textAlignment = .right
        contentView.backgroundColor = .white
        contentView.addSubview(grandTotalLabel)
        contentView.addSubview(totalAmountLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// generate the child of the view
    private func generateChildrens() {
        NSLayoutConstraint.activate([
            grandTotalLabel.trailingAnchor.constraint(equalTo: totalAmountLabel.leadingAnchor, constant: -20),
            grandTotalLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            totalAmountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            totalAmountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        
        ])
        
    }
    
    /// Configure the header vuew
    func configure(total: Float) {
        totalAmountLabel.text = "\(total)"
        generateChildrens()
    }
}
