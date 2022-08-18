//
//  LocalCartItemRepository.swift
//  ShoppingCart
//
//  Created by ebpearls on 18/08/2022.
//

import Foundation

protocol Repository {
    associatedtype Object
    
    func create(_ object: Object)
    func find(_ predicate: NSPredicate) -> Object?
    func update(_ object: Object)
    func delete(_ object: Object)
}


class LocalCartItemRepository: Repository {
    
    typealias Object = CartItem.Object
    
    private let storageProvider: StorageProvider
    
    init(storageProvider: StorageProvider) {
        self.storageProvider = storageProvider
    }
    
    func create(_ object: CartItem.Object) {
        storageProvider.create(object)
    }
    
    func find(_ predicate: NSPredicate) -> CartItem.Object? {
        storageProvider.find(predicate)
    }
    
    func update(_ object: CartItem.Object) {
        storageProvider.update(NSPredicate(format: "%K == %@", #keyPath(CartItem.itemId), object.id), object)
    }
    
    func delete(_ object: CartItem.Object) {
        storageProvider.delete(predicate: NSPredicate(format: "%K == %@", #keyPath(CartItem.itemId), object.id), type: CartItem.Object.self)
    }
    
    
}
