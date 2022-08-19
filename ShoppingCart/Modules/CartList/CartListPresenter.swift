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
    func itemModelFor(at index: Int) -> CartItem.Object?
}

/// Protocol for CartList Presenter delegate
protocol CartListPresenterDelegate: UIViewController {
    func loadItemList()
    func showLoadingUI()
    func showAlert(title: String, message: String)
    
    func itemsWillUpdate()
    func itemsUpdated()
    func insertItem(at indexpath: IndexPath)
    func updateItem(at indices: [IndexPath])
    func removeItem(at indexpath: IndexPath)
}

/// Presenter of Cart list
class CartListPresenter: NSObject, CartListPresentable {
    
    typealias DataModel = CartItem

    private let localCartItemRepository: LocalRepository<DataModel>
    private let router: CartListRoutable
    private var cartItems: [CartItem] {
        var cartItems = [CartItem]()
        dbContext.performAndWait({
            cartItems = fetchedResultsController.fetchedObjects ?? []
        })
        return cartItems
    }
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
            delegate?.loadItemList()
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
    
    func itemModelFor(at index: Int) -> CartItem.Object? {
        guard index < cartItems.count else { return nil }
        return cartItems[index].createObject()
    }

    private func fetchCartItems() throws {
        fetchedResultsController.delegate = self
        try fetchedResultsController.performFetch()
    }
    
    func addItem(name: String, image: String?, tax: Float, quantity: Int16, price: Float) {
        let itemObject = CartItem.Object(id: UUID().uuidString, name: name, image: image, tax: tax, quantity: quantity, price: price, updatedAt: Date())
        localCartItemRepository.create(itemObject)
    }
    
    func updateItem(id: String, name: String, image: String?, tax: Float, quantity: Int16, price: Float) {
        let itemObject = CartItem.Object(id: id, name: name, image: image, tax: tax, quantity: quantity, price: price, updatedAt: Date())
        let predicate = NSPredicate(format: "%K == %@", #keyPath(CartItem.itemId), itemObject.id)
        localCartItemRepository.update(predicate, itemObject)
    }
    
    func delete(id: String) {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(CartItem.itemId), id)
        localCartItemRepository.delete(predicate)
    }
    
}

extension CartListPresenter: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.itemsWillUpdate()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { fatalError("Index path should be not nil") }
            debugPrint("Item created for row: \(String(describing: newIndexPath.row))")
            delegate?.insertItem(at: newIndexPath)
        case .update:
            guard let newIndexPath = newIndexPath else { fatalError("Index path should be not nil") }
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            debugPrint("Item updated for rows: \(String(describing: newIndexPath.row)) , \(String(describing: indexPath.row))")
            delegate?.updateItem(at: [newIndexPath, indexPath])
        case .move:
            break
        case .delete:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            debugPrint("Item deleted for row: \(String(describing: indexPath.row))")
            delegate?.removeItem(at: indexPath)
        @unknown default: break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.itemsUpdated()
    }
    
}

