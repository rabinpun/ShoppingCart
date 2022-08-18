//
//  CartItem.swift
//  ShoppingCart
//
//  Created by ebpearls on 18/08/2022.
//

import Foundation
import CoreData

@objc(CartItem)
class CartItem : NSManagedObject {
    @NSManaged var itemId: String
    @NSManaged var name: String
    @NSManaged var image: String?
    @NSManaged var tax: Float
    @NSManaged var quantity: Int16
    @NSManaged var price: Float
    @NSManaged var updatedAt: Date
}

extension CartItem {
    
    struct Object: DatabaseObjectRepresentation {
        func updateObject(_ object: CartItem) {
            object.name = name
            object.tax = tax
            object.price = price
            object.image = image
            object.quantity = quantity
        }
        
        typealias Entity = CartItem
        
        let id: String
        var name: String
        var image: String?
        var tax: Float
        var quantity: Int16
        var price: Float
        var updatedAt: Date
    }
    
}

extension CartItem: DatabaseObject {
    func createObject() -> Object {
        Object(id: itemId, name: name, image: image, tax: tax, quantity: quantity, price: price, updatedAt: updatedAt)
    }
}


