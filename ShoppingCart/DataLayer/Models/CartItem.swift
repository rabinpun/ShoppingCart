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

extension CartItem: DatabaseObject {
    func createObject() -> Object {
        Object(id: itemId, name: name, image: image, tax: tax, quantity: quantity, price: price, updatedAt: updatedAt)
    }
}


