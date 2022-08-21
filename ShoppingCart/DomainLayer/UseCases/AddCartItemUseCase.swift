//
//  AddCartItemUseCase.swift
//  ShoppingCart
//
//  Created by ebpearls on 21/08/2022.
//

import Foundation

protocol AddDataUseCaseProtocol {
    associatedtype Entity: DatabaseObject
    
    func create(_ object: Entity.Object)
}


struct AddCartItemUseCase: AddDataUseCaseProtocol {
    
    
    typealias Entity = CartItem
    
    private let localCartItemRepository: LocalRepository<Entity>
    
    init(localCartItemRepository:  LocalRepository<Entity>) {
        self.localCartItemRepository = localCartItemRepository
    }
    
    func create(_ object: CartItem.Object) {
        localCartItemRepository.create(object)
    }
}
