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

enum InitialItem: String, CaseIterable {
    case friedrice, soup, pasta, salad, strawberryicecream, kattiroll, sushi, momo, chowmein, burger, pizza
}

class LocalRepository<T: DatabaseObject>: Repository {
    
    typealias Entity = T
    
    private var isFirstInstall: Bool {
        get {
            !UserDefaults.standard.bool(forKey: "isFirstInstall")
        }
        set {
            UserDefaults.standard.set(!newValue, forKey: "isFirstInstall")
        }
    }
    
    private let storageProvider: StorageProvider
    
    init(storageProvider: StorageProvider) {
        self.storageProvider = storageProvider
        addInitialItems()
    }
    
    func create(_ object: Entity.Object) {
        storageProvider.create(object)
    }
    
    func find(_ predicate: NSPredicate) -> Entity.Object? {
        storageProvider.find(predicate)
    }
    
    func update(_ predicate: NSPredicate,_ object: Entity.Object) {
        storageProvider.update(predicate, object)
    }
    
    func delete(_ predicate: NSPredicate) {
        storageProvider.delete(predicate: predicate, type: Entity.Object.self)
    }
    
    private func addInitialItems() {
        guard isFirstInstall else { return }
        isFirstInstall = false
        InitialItem.allCases.map({ CartItem.Object(id: UUID().uuidString, name: $0.rawValue, image: $0.rawValue, tax: 15, quantity: Int16.random(in: 1...5), price: 50 * Float(Int.random(in: 1...5)), updatedAt: Date()) }).forEach({ create($0 as! T.Object) })
    }
    
}
