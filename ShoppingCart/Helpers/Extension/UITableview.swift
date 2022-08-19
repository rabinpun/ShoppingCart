//
//  UITableview.swift
//  ShoppingCart
//
//  Created by ebpearls on 19/08/2022.
//

import UIKit

extension UITableView {

    /// Registers a particular cell using its reuse-identifier
    func registerCell<T: UITableViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: String(describing: T.self))
    }
}
