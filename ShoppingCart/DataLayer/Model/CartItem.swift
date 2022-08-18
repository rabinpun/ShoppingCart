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
    @NSManaged var name: String
    @NSManaged var image: String?
    @NSManaged var tax: Float
    @NSManaged var quantity: Int16
    @NSManaged var price: Float
}

extension CartItem {
    
    struct Object {
        let name: String
        let image: String?
        let tax: Float
        let quantity: Int16
        let price: Float
    }
    
    func getObject() -> Object {
        Object(name: name, image: image, tax: tax, quantity: quantity, price: price)
    }
    
}
