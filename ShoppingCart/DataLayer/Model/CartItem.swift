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
        let name: String
        let image: String?
        let tax: Float
        let quantity: Int16
        let price: Float
    }
    
}

extension CartItem: DatabaseObject {
    func createObject() -> Object {
        Object(id: itemId, name: name, image: image, tax: tax, quantity: quantity, price: price)
    }
}


