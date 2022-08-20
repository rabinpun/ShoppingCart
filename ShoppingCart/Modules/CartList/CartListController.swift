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


