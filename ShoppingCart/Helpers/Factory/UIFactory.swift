//
//  UIFactory.swift
//  ShoppingCart
//
//  Created by ebpearls on 19/08/2022.
//

import UIKit

final class UIFactory {
    
    static func label(font: UIFont = .systemFont(ofSize: .FontSize.regular.value), textColor: UIColor = .black, text: String = "") -> UILabel {
        let label = UILabel(frame: .zero)
        label.font = font
        label.textColor = textColor
        label.text = text
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func imageButton(image: UIImage, fill: Bool = false, tintColor: UIColor = .white, withRenderingMode: Bool = false) -> UIButton {
        let button = UIButton()
        button.setImage( withRenderingMode ? image.withRenderingMode(.alwaysTemplate) : image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        if fill {
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
        }
        button.tintColor = tintColor
        return button
    }
    
    static func textButton(text: String, textColor: UIColor = .white, backgroundColor: UIColor = .black, cornerRadius: CGFloat = 0, borderColor: UIColor? = nil) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        if cornerRadius != 0 {
            button.layer.cornerRadius = cornerRadius
        }
        if let borderColor = borderColor {
            button.layer.borderColor = borderColor.cgColor
            button.layer.borderWidth = 1
        }
        button.backgroundColor = backgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    static func imageView(image: UIImage? = nil, contentMode: UIView.ContentMode, tintColor: UIColor? = nil) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = contentMode
        if let tintColor = tintColor {
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = tintColor
        }
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    static func textField(font: UIFont = .systemFont(ofSize: .FontSize.regular.value), placeholder: String = "", textColor: UIColor = .white, keyBoardType: UIKeyboardType) -> UITextField {
        let textField = Textfield(frame: .zero)
        textField.textColor = textColor
        textField.keyboardType = keyBoardType
        textField.placeholder = placeholder
        return textField
    }
    
    static func stackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = .equalSpacing
        return stackView
    }
    
}

final class Textfield: UITextField {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: frame.height, width: frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        layer.addSublayer(bottomLine)
    }
    
}
