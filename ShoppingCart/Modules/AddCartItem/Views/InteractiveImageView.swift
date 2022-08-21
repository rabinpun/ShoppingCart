//
//  InteractiveImageView.swift
//  ShoppingCart
//
//  Created by ebpearls on 21/08/2022.
//

import UIKit

protocol InteractiveImageViewDelegate: AnyObject {
    func addButtonClicked()
    func removeButtonClicked()
}

final class InteractiveImageView: UIView {
    
    weak var delegate: InteractiveImageViewDelegate?
    
    private lazy var addButton = UIFactory.imageButton(image: UIImage(systemName: "plus")!, fill: true, tintColor: .green)
    private lazy var removeButton = UIFactory.imageButton(image: UIImage(systemName: "multiply")!, fill: true, tintColor: .red)
    private lazy var imageView = UIFactory.imageView(image: UIImage(systemName: "photo"),contentMode: .scaleAspectFit)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        addViews()
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removeButtonClicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        removeButton.isHidden = true
        [addButton, removeButton].forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })
        [imageView, addButton, removeButton].forEach({ addSubview($0) })
        
        NSLayoutConstraint.activate([
        
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
            
            addButton.widthAnchor.constraint(equalToConstant: 20),
            addButton.heightAnchor.constraint(equalToConstant: 20),
            addButton.centerXAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -5),
            addButton.centerYAnchor.constraint(equalTo: imageView.topAnchor, constant: 15),
            
            removeButton.widthAnchor.constraint(equalToConstant: 20),
            removeButton.heightAnchor.constraint(equalToConstant: 20),
            removeButton.centerXAnchor.constraint(equalTo: imageView.trailingAnchor),
            removeButton.centerYAnchor.constraint(equalTo: imageView.topAnchor),
        
        ])
    }
    
    @objc private func addButtonClicked() {
        delegate?.addButtonClicked()
    }
    
    @objc private func removeButtonClicked() {
        delegate?.removeButtonClicked()
    }
    
    func setImage(_ image: UIImage?) {
        imageView.image = image != nil ? image : UIImage(systemName: "photo")
        addButton.isHidden = image != nil
        removeButton.isHidden = image == nil
    }
    
}
