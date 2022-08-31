//
//  Image.swift
//  ShoppingCart
//
//  Created by ebpearls on 22/08/2022.
//

import UIKit

enum Image {
    case systemImage(String), assetImage(String)
}

extension UIImage {
    
    private static func image(_ image: Image) -> UIImage {
        switch image {
        case .systemImage(let name):
            return UIImage(systemName: name)!
        case .assetImage(let name):
            return UIImage(named: name)!
        }
    }
    
    static var defaultPhoto: UIImage {
        image(.systemImage("photo"))
    }
    
    static var plus: UIImage {
        image(.systemImage("plus"))
    }
    
    static var minus: UIImage {
        image(.systemImage("minus"))
    }
    
    static var multiply: UIImage {
        image(.systemImage("multiply"))
    }
    
    static var profileImage: UIImage {
        image(.assetImage("profileImage"))
    }
    
    static var chevronLeft: UIImage {
        image(.systemImage("chevron.left"))
    }
    
    static var delete: UIImage {
        image(.systemImage("trash"))
    }
    
    static var settings: UIImage {
        image(.systemImage("gear"))
    }
    
    static func flagImage(name: String) -> UIImage {
        image(.assetImage(name))
    }
    
}

