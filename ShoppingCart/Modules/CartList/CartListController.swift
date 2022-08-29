//
//  ViewController.swift
//  ShoppingCart
//
//  Created by ebpearls on 17/08/2022.
//

import UIKit
import Combine

/// Controller for Cartlist
final class CartListController: UIViewController {
    
    private let tableCellHeight: CGFloat = 70
    private let tableHeaderHeight: CGFloat = 40
    private let tableFooterHeight: CGFloat = 100
    private var alertCancellable: AnyCancellable?
    
    var presenter: CartListPresentable!
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.registerCell(CartListCell.self)
        view.registerHeaderFooter(CartListHeader.self)
        view.registerHeaderFooter(CartListFooter.self)
        let headerView = CartListHeaderView()
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        view.tableHeaderView = headerView
        view.separatorStyle = .singleLine
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        view.backgroundColor = .white
        title = "Your orders"
        presenter.setup()
        setupNavigationButtons()
        addTableView()
    }
    
    private func addTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupNavigationButtons() {
        let rightBarButton = UIBarButtonItem(image: .plus, style: .done, target: self, action: #selector(rightBarButtonClicked))
        rightBarButton.tintColor = .black
        navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    @objc private func rightBarButtonClicked() {
        presenter.addItem()
    }
    
}

extension CartListController: CartListPresenterDelegate {
    
    func loadItemList() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func showAlert(title: String, message: String, alertActions: [AlertAction]) {
        alertCancellable = alert(title: title, msg: message, actions: alertActions).sink { alert in
            alert.actionClosure?()
        }
    }
    
}

/// Table view delegate confirmance
extension CartListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectItem(at: indexPath.row)
    }
    
}

/// Table view datasource confirmance
extension CartListController: UITableViewDataSource {
    
    private var listIsEmpty: Bool {
        presenter.numberOfItems() == 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemModel = presenter.itemModelFor(at: indexPath.row) else { fatalError("Item for index is not present.") }
        let cell = tableView.dequeueReusableCell(withIdentifier: CartListCell.identifier, for: indexPath) as! CartListCell
        cell.configure(with: itemModel, delegate: self)
        if let imageName = itemModel.image, let image = presenter.imageFor(imageName) {
            cell.itemImageView.image = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listIsEmpty ? tableView.setEmptyMessage("No items in cart.") : tableView.restore()
        return presenter.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !listIsEmpty else { return nil }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CartListHeader.identifier) as! CartListHeader
        header.configure()
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard !listIsEmpty else { return nil }
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: CartListFooter.identifier) as! CartListFooter
        footer.configure(total: presenter.getGrandTotal())
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        listIsEmpty ? 0 : tableHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        listIsEmpty ? 0 : tableFooterHeight
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
        DispatchQueue.main.async {
            self.tableView.insertRows(at: [indexpath], with: .fade)
        }
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
            guard let footerView = self.tableView.footerView(forSection: section) as? CartListFooter else { return }
            footerView.configure(total: self.presenter.getGrandTotal())
        }
    }
}
