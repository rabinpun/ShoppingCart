//
//  CartListPresenter.swift
//  ShoppingCart
//
//  Created by ebpearls on 18/08/2022.
//

import UIKit
import CoreData

/// Protocol for cartlist presenter
protocol CartListPresentable {
    var delegate: CartListPresenterDelegate? { get set }

    func setup()
    func didSelectItem(at index: Int)
    func numberOfItems() -> Int
    func itemModelFor(index: Int) -> CartItem.Object?
}

/// Protocol for CartList Presenter delegate
protocol CartListPresenterDelegate: UIViewController {
    func loadItemList()
    func showLoadingUI()
    func showAlert(title: String, message: String)
}

/// Presenter of Cart list
class CartListPresenter: CartListPresentable {
    
    typealias DataModel = CartItem

    private let localCartItemRepository: LocalRepository<DataModel>
    private let router: CartListRoutable
    private var cartItems: [CartItem] = []
    private let dbContext: NSManagedObjectContext
    
    lazy var fetchedResultsController: NSFetchedResultsController<DataModel> = {
        let request = NSFetchRequest<DataModel>(entityName: DataModel.entityName)
        let sort = NSSortDescriptor(key: #keyPath(CartItem.updatedAt), ascending: false)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: dbContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()

    weak var delegate: CartListPresenterDelegate?
    
    init(router: CartListRoutable, localCartItemRepository: LocalRepository<CartItem>, dbContext: NSManagedObjectContext) {
        self.router = router
        self.localCartItemRepository = localCartItemRepository
        self.dbContext = dbContext
    }

    func setup() {
        do {
            try fetchCartItems()
        } catch {
            delegate?.showAlert(title: "Error", message: "Failed to fech cart items.")
        }
    }
    
    func didSelectItem(at index: Int) {
        let cartItem = cartItems[index].createObject()
        router.pushDetailView(with: cartItem)
    }
    
    func numberOfItems() -> Int {
        cartItems.count
    }
    
    func itemModelFor(index: Int) -> CartItem.Object? {
        guard index < cartItems.count else { return nil }
        return cartItems[index].createObject()
    }

    private func fetchCartItems() throws {
        try fetchedResultsController.performFetch()
    }
    
}

