//
//  CartListPresenter.swift
//  ShoppingCart
//
//  Created by ebpearls on 18/08/2022.
//

import UIKit
import CoreData

/// Protocol for CartList Presenter delegate
protocol CartListPresenterDelegate: UIViewController {
    func loadItemList()
    func showAlert(title: String, message: String, alertActions: [AlertAction])
    
    func itemsWillUpdate()
    func itemsUpdated()
    func insertItem(at indexpath: IndexPath)
    func updateItem(at indices: [IndexPath])
    func removeItem(at indexpath: IndexPath)
    func updateFooter(at section: Int)
}

/// Protocol for cartlist presenter
protocol CartListPresentable {
    var delegate: CartListPresenterDelegate? { get set }

    func setup()
    func didSelectItem(at index: Int)
    func numberOfItems() -> Int
    func itemModelFor(at index: Int) -> CartItem.Object?
    func changeItemQuantityFor(_ index: Int, increase: Bool)
    func getGrandTotal() -> Float
}

enum CartListError: LocalizedError {
    case quantityIsZero
    
    var errorDescription: String? {
        switch self {
        case .quantityIsZero:
            return "Do you want to delete this item from cart?"
        }
    }
}

/// Presenter of Cart list
final class CartListPresenter: NSObject, CartListPresentable {
    
    typealias DataModel = CartItem

    private let updatecartItemUseCase: UpdateCartItemUseCase
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
    
    private var grandTotalAmount: Float = 0 {
        didSet {
            delegate?.updateFooter(at: 0)
        }
    }
    
    init(router: CartListRoutable, updatecartItemUseCase: UpdateCartItemUseCase, dbContext: NSManagedObjectContext) {
        self.router = router
        self.updatecartItemUseCase = updatecartItemUseCase
        self.dbContext = dbContext
    }

    func setup() {
        do {
            try fetchCartItems()
            delegate?.loadItemList()
        } catch {
            delegate?.showAlert(title: "Error", message: "Failed to fech cart items.", alertActions: [.ok(nil)])
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
        calculateGrandTotalAmount()
    }
    
    private func delete(id: String) {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(CartItem.itemId), id)
        updatecartItemUseCase.delete(predicate)
    }
    
    func changeItemQuantityFor(_ index: Int, increase: Bool) {
        guard var itemModel = itemModelFor(at: index) else { return assertionFailure("Item for index not availabel") }
        itemModel.quantity += increase ? 1 : -1
        
        func deleteCurrentItem() {
            delete(id: itemModel.id)
        }
        do {
            try updateItemIfValid(itemModel)
            grandTotalAmount += (increase ? 1 : -1) * itemModel.price
        } catch {
            delegate?.showAlert(title: "ShoppingCart", message: error.localizedDescription, alertActions: [.delete(deleteCurrentItem), .cancel(nil)])
        }
    }
    
    private func updateItemIfValid(_ object: CartItem.Object) throws {
        guard object.quantity > 0 else { throw CartListError.quantityIsZero }
        let predicate = NSPredicate(format: "%K == %@", #keyPath(CartItem.itemId), object.id)
        updatecartItemUseCase.update(predicate, object)
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
            guard let newIndexPath = newIndexPath else { fatalError("Index path should be not nil") }
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            debugPrint("Item moved for rows: \(String(describing: newIndexPath.row)) , \(String(describing: indexPath.row))")
            delegate?.updateItem(at: [newIndexPath, indexPath])
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

extension CartListPresenter {
    
    private func calculateGrandTotalAmount() {
        grandTotalAmount = cartItems.reduce(Float(0), { $0 + $1.createObject().calculateTotalPrice() })
    }
    
    func getGrandTotal() -> Float {
        grandTotalAmount
    }
    
}

