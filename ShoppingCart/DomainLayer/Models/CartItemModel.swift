//
//  CartItemModel.swift
//  ShoppingCart
//
//  Created by ebpearls on 21/08/2022.
//

import Foundation

extension CartItem {
    
    struct Object: DatabaseObjectRepresentation {
        func updateObject(_ object: CartItem) {
            object.itemId = id
            object.name = name
            object.tax = tax
            object.price = price
            object.image = image
            object.quantity = quantity
            object.updatedAt = updatedAt
        }
        
        typealias Entity = CartItem
        
        let id: String
        var name: String
        var image: String?
        var tax: Float
        var quantity: Int16
        var price: Float
        var updatedAt: Date
        
        func calculateTotalPrice() -> Float {
            Float(quantity) * (price + price * tax * 0.01)
        }
    }
    
}
