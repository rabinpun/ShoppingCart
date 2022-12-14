//
//  CartListCell.swift
//  ShoppingCart
//
//  Created by ebpearls on 19/08/2022.
//

import UIKit

extension UITableViewCell: Identifiable {}

protocol CartListCellDelegate: AnyObject {
    func subtractButtonClicked(cell: CartListCell)
    func addButtonClicked(cell: CartListCell)
}

class CartListCell: UITableViewCell {
    
    lazy var itemImageView = UIFactory.imageView(contentMode: .scaleAspectFit)
    
    lazy var itemNameLabel: UILabel = {
        let label = UIFactory.label(font: .systemFont(ofSize: .FontSize.regular.value, weight: .semibold))
        label.numberOfLines = 2
        return label
    }()
    
    lazy var priceLabel = UIFactory.label()
    
    lazy var deductButton = UIFactory.imageButton(image: .minus, tintColor: .red)
    
    lazy var addButton = UIFactory.imageButton(image: .plus, tintColor: .green)
    
    lazy var quantityLabel = UIFactory.label()
    
    lazy var quantityStackView: UIStackView = {
        let stackView = UIFactory.stackView(axis: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var totalAmountLabel = UIFactory.label()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        contentView.addSubview(itemImageView)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(quantityStackView)
        
        quantityStackView.addArrangedSubview(deductButton)
        quantityStackView.addArrangedSubview(quantityLabel)
        quantityStackView.addArrangedSubview(addButton)
        
        contentView.addSubview(totalAmountLabel)
        totalAmountLabel.textAlignment = .right
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        deductButton.addTarget(self, action: #selector(deductButtonClicked), for: .touchUpInside)
        
        generateChildrens()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addButtonClicked() {
        delegate?.addButtonClicked(cell: self)
    }
    
    @objc private func deductButtonClicked() {
        delegate?.subtractButtonClicked(cell: self)
    }
    
    /// generate the child of the view
    private func generateChildrens() {
        NSLayoutConstraint.activate([
            
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            itemImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            itemImageView.widthAnchor.constraint(equalToConstant: 50),
            
            itemNameLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 10),
            itemNameLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -40),
            itemNameLabel.centerYAnchor.constraint(equalTo: itemImageView.centerYAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: itemNameLabel.trailingAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: quantityStackView.leadingAnchor, constant: 10),
            priceLabel.centerYAnchor.constraint(equalTo: itemImageView.centerYAnchor),
            
            quantityStackView.trailingAnchor.constraint(equalTo: totalAmountLabel.leadingAnchor, constant: -10),
            quantityStackView.centerYAnchor.constraint(equalTo: itemImageView.centerYAnchor),
            quantityStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            quantityStackView.widthAnchor.constraint(equalToConstant: 65),
            
            totalAmountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            totalAmountLabel.centerYAnchor.constraint(equalTo: itemImageView.centerYAnchor),
            totalAmountLabel.widthAnchor.constraint(equalToConstant: 60),
        
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
    }
    
    private weak var delegate: CartListCellDelegate?
    
    /// Configure the cell with object model
    /// - Parameter item: cart item
    func configure(with item: CartItem.Object, delegate: CartListCellDelegate) {
        self.delegate = delegate
        selectionStyle = .none
        
        itemNameLabel.text = item.name
        itemImageView.image = item.image != nil ? UIImage(systemName: item.image!) : .defaultPhoto
        let priceText = "$\(item.price) \n(\(item.tax)%)"
        let attributedString = NSMutableAttributedString(string: priceText)
        let nsRange = NSString(string: priceText).range(of: "(\(item.tax)%)", options: .caseInsensitive)
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: .FontSize.small.value), .foregroundColor: UIColor.lightGray], range: nsRange)
        priceLabel.attributedText = attributedString
        quantityLabel.text = "\(item.quantity)"
        totalAmountLabel.text = "$\(item.calculateTotalPrice())"
    }
}
