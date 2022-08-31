//
//  LanguageCell.swift
//  ShoppingCart
//
//  Created by ebpearls on 31/08/2022.
//

import UIKit

class LanguageCell: UITableViewCell {
    
    lazy var itemImageView = UIFactory.imageView(contentMode: .scaleAspectFit)
    
    lazy var itemNameLabel: UILabel = {
        let label = UIFactory.label(font: .systemFont(ofSize: .FontSize.regular.value, weight: .semibold))
        label.numberOfLines = 2
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        contentView.addSubview(itemImageView)
        contentView.addSubview(itemNameLabel)
        
        generateChildrens()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// generate the child of the view
    private func generateChildrens() {
        NSLayoutConstraint.activate([
            
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            itemImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            itemImageView.widthAnchor.constraint(equalToConstant: 50),
            
            itemNameLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 10),
            itemNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            itemNameLabel.centerYAnchor.constraint(equalTo: itemImageView.centerYAnchor),
        
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
    }
    
    /// Configure the cell with object model
    /// - Parameter item: cart item
    func configure(with language: Language) {
        selectionStyle = .gray
        
        itemNameLabel.text = language.rawValue.capitalized
        itemImageView.image = language.image
    }
}
