//
//  UIViewController.swift
//  ShoppingCart
//
//  Created by ebpearls on 20/08/2022.
//

import UIKit
import Combine

struct AlertAction {
    let title: String
    let destructive: Bool
}

extension UIViewController {
    
    /// Method to present alert with actions provided
    /// - Parameters:
    ///   - title: the title of alert
    ///   - msg: the message of alert
    ///   - actions: the actions to display
    func alert(title: String, msg: String, actions: [AlertAction]) -> AnyPublisher<AlertAction, Never> {
        
        Future<AlertAction, Never> { [weak self] promise in
            guard let self = self else { return }
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            actions.forEach { action in
                let alertAction = UIAlertAction(title: action.title, style: action.destructive ? .destructive: .default) { _ in
                    promise(.success(action))
                }
                alert.addAction(alertAction)
            }
            self.present(alert, animated: true, completion: nil)
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }

}
