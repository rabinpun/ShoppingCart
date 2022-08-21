//
//  FetchAndUpdateCartItemUseCase.swift
//  ShoppingCart
//
//  Created by ebpearls on 21/08/2022.
//

import Foundation

protocol UpdateDataUseCaseProtocol {
    associatedtype Entity: DatabaseObject
    
    func update(_ predicate: NSPredicate,_ object: Entity.Object)
    func delete(_ predicate: NSPredicate)
}


struct UpdateCartItemUseCase: UpdateDataUseCaseProtocol {
    
    typealias Entity = CartItem
    
    private let localCartItemRepository: LocalRepository<Entity>
    
    init(localCartItemRepository:  LocalRepository<Entity>) {
        self.localCartItemRepository = localCartItemRepository
    }
    
    func update(_ predicate: NSPredicate, _ object: CartItem.Object) {
        localCartItemRepository.update(predicate, object)
    }
    
    func delete(_ predicate: NSPredicate) {
        localCartItemRepository.delete(predicate)
    }
}
