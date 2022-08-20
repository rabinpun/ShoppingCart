//
//  ViewController.swift
//  ShoppingCart
//
//  Created by ebpearls on 17/08/2022.
//

import UIKit
import Combine

/// Controller for Cartlist
class CartListController: UIViewController {
    
    private let tableCellHeight: CGFloat = 70
    private let tableHeaderHeight: CGFloat = 40, tableFooterHeight: CGFloat = 40
    private var alertCancellable: AnyCancellable?
    
    var presenter: CartListPresentable!
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.registerCell(CartListCell.self)
        view.registerCell(ListErrorCell.self)
        view.registerHeaderFooter(CartListHeader.self)
        view.registerHeaderFooter(CartListFooter.self)
        view.separatorStyle = .singleLine
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
    
    func showAlert(title: String, message: String, alertActions: [AlertAction]) {
        alertCancellable = alert(title: title, msg: message, actions: alertActions).sink { alert in
            alert.actionClosure?()
        }
    }
    
}

/// Table view delegate confirmance
extension CartListController: UITableViewDelegate {
    
    
}

/// Table view datasource confirmance
extension CartListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if presenter.numberOfItems() == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ListErrorCell.identifier, for: indexPath) as! ListErrorCell
            cell.configure(with: "No items in cart.")
            return cell
        }
        guard let itemModel = presenter.itemModelFor(at: indexPath.row) else { fatalError("Item for index is not present.") }
        let cell = tableView.dequeueReusableCell(withIdentifier: CartListCell.identifier, for: indexPath) as! CartListCell
        cell.configure(with: itemModel, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfItems() == 0 ? 1 : presenter.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CartListHeader.identifier) as! CartListHeader
        header.configure()
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CartListFooter.identifier) as! CartListFooter
        header.configure(total: presenter.getGrandTotal())
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        tableFooterHeight
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
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
        }
    }
    
    func itemsUpdated() {
        DispatchQueue.main.async {
            self.tableView.endUpdates()
        }
    }
    
    func insertItem(at indexpath: IndexPath) {
        
    }
    
    func updateItem(at indices: [IndexPath]) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: indices, with: .fade)
        }
    }
    
    func removeItem(at indexpath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.deleteRows(at: [indexpath], with: .fade)
        }
    }
    
    func updateFooter(at section: Int) {
        DispatchQueue.main.async {
            let footerView = self.tableView.footerView(forSection: section) as! CartListFooter
            footerView.configure(total: self.presenter.getGrandTotal())
        }
    }
}
