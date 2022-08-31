//
//  UIViewController.swift
//  ShoppingCart
//
//  Created by ebpearls on 20/08/2022.
//

import UIKit
import Combine

protocol AlertActionable {
    var title: String { get }
    var style: UIAlertAction.Style { get }
    var actionClosure: (() -> Void)? { get }
}

typealias AlertActionClosure = (() -> Void)?


enum AlertAction: AlertActionable {
    case ok(AlertActionClosure), cancel, delete(AlertActionClosure), takePhoto(AlertActionClosure), openGallery(AlertActionClosure), setting(AlertActionClosure)
    
    var title: String {
        switch self {
        case .ok:
            return LocalizedKey.ok.value
        case .cancel:
            return LocalizedKey.cancel.value
        case .delete:
            return LocalizedKey.delete.value
        case .takePhoto:
            return LocalizedKey.takePhoto.value
        case .openGallery:
            return LocalizedKey.openGallery.value
        case .setting:
            return LocalizedKey.setting.value
        }
    }
    var style: UIAlertAction.Style {
        switch self {
        case .cancel:
            return .cancel
        case .delete:
            return .destructive
        default:
            return .default
        }
    }

    var actionClosure: (() -> Void)? {
        switch self {
        case .ok(let alertActionClosure), .delete(let alertActionClosure), .openGallery(let alertActionClosure), .takePhoto(let alertActionClosure), .setting(let alertActionClosure):
            return alertActionClosure
        case .cancel:
            return nil
        }
    }
    
    
    
    
}

extension UIViewController {
    
    /// Method to present alert with actions provided
    /// - Parameters:
    ///   - title: the title of alert
    ///   - msg: the message of alert
    ///   - actions: the actions to display
    func alert(title: String? = nil, msg: String? = nil, actions: [AlertAction], style: UIAlertController.Style = .alert) -> AnyPublisher<AlertAction, Never> {
        
        Future<AlertAction, Never> { [weak self] promise in
            guard let self = self else { return }
            let alert = title == nil && msg == nil ? UIAlertController() : UIAlertController(title: title, message: msg, preferredStyle: style)
            actions.forEach { action in
                let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
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
