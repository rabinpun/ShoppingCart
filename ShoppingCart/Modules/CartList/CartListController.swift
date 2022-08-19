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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}

extension CartListController: CartListPresenterDelegate {
    
    func loadItemList() {
        
    }
    
    func showLoadingUI() {
        
    }
    
    func showAlert(title: String, message: String) {
        
    }
    
}
