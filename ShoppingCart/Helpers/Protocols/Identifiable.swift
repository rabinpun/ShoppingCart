//
//  Identifiable.swift
//  ShoppingCart
//
//  Created by ebpearls on 20/08/2022.
//

import Foundation

protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String {
        String(describing: self)
    }
}
