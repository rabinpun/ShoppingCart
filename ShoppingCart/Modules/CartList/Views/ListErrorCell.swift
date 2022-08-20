//
//  ListErrorCell.swift
//  ShoppingCart
//
//  Created by ebpearls on 20/08/2022.
//

import UIKit

class ListErrorCell: UITableViewCell {
    
    lazy var messageLabel: UILabel = {
        let label = UIFactory.label()
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    func configure(with message: String) {
        selectionStyle = .none
        
        messageLabel.text = message
        
        generateChildren()
    }
    
    private func generateChildren() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
        ])
        
    }
    
}
