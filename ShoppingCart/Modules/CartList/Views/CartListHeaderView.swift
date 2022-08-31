//
//  CartListHeaderView.swift
//  ShoppingCart
//
//  Created by ebpearls on 22/08/2022.
//

import UIKit

final class CartListHeaderView: UIView {
    
    lazy var profileImageView = UIFactory.imageView(image: .profileImage,contentMode: .scaleAspectFill)
    lazy var nameLabel = UIFactory.label(font: .systemFont(ofSize: .FontSize.medium.value, weight: .semibold), text: LocalizedKey.userName.value)
    lazy var descripionLabel = UIFactory.label(textColor: .lightGray, text: LocalizedKey.userAddress.value)
    lazy var balanceLabel = UIFactory.label(font: .systemFont(ofSize: .FontSize.medium.value), textColor: .systemGreen, text: "$1000")
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addViews()
    }
    
    private func addViews() {
        profileImageView.layer.cornerRadius = 50
        [profileImageView, nameLabel, descripionLabel, balanceLabel].forEach({ addSubview($0) })
        
        NSLayoutConstraint.activate([
            
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -40),
            
            descripionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descripionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            
//            descripionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            balanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            balanceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

