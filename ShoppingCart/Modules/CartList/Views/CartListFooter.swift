//
//  CartListFooter.swift
//  ShoppingCart
//
//  Created by ebpearls on 20/08/2022.
//

import UIKit

class CartListFooter: UITableViewHeaderFooterView {
    
    private let buttonHeight: CGFloat = 40
    lazy var grandTotalLabel: UILabel = UIFactory.label(font: .systemFont(ofSize: .FontSize.regular.value, weight: .semibold), textColor: .white, text: LocalizedKey.grandTotal.value)
    private lazy var payButton = UIFactory.textButton(text: LocalizedKey.continuePayment.value, textColor: .systemGreen, backgroundColor: .white, cornerRadius: buttonHeight * 0.25, borderColor: .systemGreen)
    lazy var totalAmountLabel: UILabel = UIFactory.label(textColor: .white)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        totalAmountLabel.textAlignment = .right
        contentView.backgroundColor = .black
        [grandTotalLabel, totalAmountLabel, payButton].forEach({ contentView.addSubview($0) })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// generate the child of the view
    private func generateChildrens() {
        NSLayoutConstraint.activate([
            grandTotalLabel.trailingAnchor.constraint(equalTo: totalAmountLabel.leadingAnchor, constant: -20),
            grandTotalLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            totalAmountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            totalAmountLabel.centerYAnchor.constraint(equalTo: grandTotalLabel.centerYAnchor),
        
            payButton.topAnchor.constraint(equalTo: totalAmountLabel.bottomAnchor, constant: 10),
            payButton.trailingAnchor.constraint(equalTo: totalAmountLabel.trailingAnchor),
            payButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            payButton.widthAnchor.constraint(equalToConstant: 200),
            
        ])
        
    }
    
    /// Configure the header vuew
    func configure(total: Float) {
        totalAmountLabel.text = "$\(total)"
        generateChildrens()
    }
}
