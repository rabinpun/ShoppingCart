//
//  ViewController.swift
//  ShoppingCart
//
//  Created by ebpearls on 17/08/2022.
//

import UIKit

/// Controller for Cartlist
class CartListController: UIViewController {
    
    var presenter: CartListPresentable!
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.registerCell(CartListCell.self)
        view.registerCell(ListErrorCell.self)
        view.registerHeaderFooter(CartLisCartListHeadertCell.self)
        view.separatorStyle = .none
        view.backgroundColor = .clear
        return view
    }()

    override func viewDidLoad() {
        view.backgroundColor = .white
        presenter.setup()
        
        addTableView()
    }
    
    private func addTableView() {
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension CartListController: CartListPresenterDelegate {
    
    func loadItemList() {
        debugPrint(presenter.numberOfItems())
    }
    
    func showLoadingUI() {
        
    }
    
    func showAlert(title: String, message: String) {
        
    }
    
}

/// Table view delegate confirmance
extension CartListController: UITableViewDelegate {
    
    
}

/// Table view datasource confirmance
extension CartListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemModel = presenter.itemModelFor(at: indexPath.row) else { fatalError("Item for index is not present.") }
        let cell = tableView.dequeueReusableCell(withIdentifier: CartListCell.identifier, for: indexPath) as! CartListCell
        cell.configure(with: itemModel, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CartLisCartListHeadertCell.identifier) as! CartLisCartListHeadertCell
        header.configure()
        return header
    }
    
}

/// CartListCellDelegate functions
extension CartListController: CartListCellDelegate {
    
    func subtractButtonClicked(cell: CartListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { fatalError("Item index is not nil.") }
        presenter.changeItemQuantityFor(indexPath.row, increase: false)
    }
    
    func addButtonClicked(cell: CartListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { fatalError("Item index is not nil.") }
        presenter.changeItemQuantityFor(indexPath.row, increase: true)
    }
    
}

/// Item update delegate functions
extension CartListController {
    
    func itemsWillUpdate() {
        tableView.beginUpdates()
    }
    
    func itemsUpdated() {
        tableView.endUpdates()
    }
    
    func insertItem(at indexpath: IndexPath) {
        
    }
    
    func updateItem(at indices: [IndexPath]) {
        tableView.reloadRows(at: indices, with: .fade)
    }
    
    func removeItem(at indexpath: IndexPath) {
        
    }
}
