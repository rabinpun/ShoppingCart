//
//  LocalCartItemRepository.swift
//  ShoppingCart
//
//  Created by ebpearls on 18/08/2022.
//

import Foundation

protocol Repository {
    associatedtype Entity: DatabaseObject
    
    func create(_ object: Entity.Object)
    func find(_ predicate: NSPredicate) -> Entity.Object?
    func update(_ predicate: NSPredicate,_ object: Entity.Object)
    func delete(_ predicate: NSPredicate)
}

//protocol CartItemRepository: Repository where Object == CartItem.Object { }

class LocalRepository<T: DatabaseObject>: Repository {
    
    typealias Entity = T
    
    private let storageProvider: StorageProvider
    
    init(storageProvider: StorageProvider) {
        self.storageProvider = storageProvider
    }
    
    func create(_ object: Entity.Object) {
        storageProvider.create(object)
    }
    
    func find(_ predicate: NSPredicate) -> Entity.Object? {
        storageProvider.find(predicate)
    }
    
    func update(_ predicate: NSPredicate,_ object: Entity.Object) {
        //NSPredicate(format: "%K == %@", #keyPath(CartItem.itemId), object.id)
        storageProvider.update(predicate, object)
    }
    
    func delete(_ predicate: NSPredicate) {
        //NSPredicate(format: "%K == %@", #keyPath(CartItem.itemId), object.id)
        storageProvider.delete(predicate: predicate, type: Entity.Object.self)
    }
    
}
