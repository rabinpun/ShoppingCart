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
        register(cellClass, forCellReuseIdentifier: T.identifier)
    }
    
    /// Registers a particular header footer using its reuse-identifier
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ headerFooterClass: T.Type) {
        register(headerFooterClass, forHeaderFooterViewReuseIdentifier: T.identifier)
    }
    
    func setEmptyMessage(_ message: String) {
        
        let label = UIFactory.label(text: message)
        label.textAlignment = .center
        self.backgroundView = label
        self.separatorStyle = .none
        }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
