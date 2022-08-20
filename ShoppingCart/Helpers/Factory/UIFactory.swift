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
    
    static func imageView(image: UIImage? = nil, contentMode: UIView.ContentMode, tintColor: UIColor? = nil) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = contentMode
        if let tintColor = tintColor {
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = tintColor
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
}
