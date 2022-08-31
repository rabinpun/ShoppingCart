//
//  Localization.swift
//  Shopping Cart
//
//  Created by ebpearls on 31/08/2022.
//

import Foundation
import SwiftUI

private protocol Localizable {
    var key: String { get }
    var value: String { get }
}

private struct Localizer {
    static func localized(key: Localizable, tableName: String? = LanguageManager.currentLanguage.rawValue.capitalized, bundle: Bundle = .main, value: String = "", comment: String = "", param: CVarArg...) -> String {
        let localizedString = NSLocalizedString(key.key, tableName: tableName, bundle: bundle, value: value, comment: comment)
        let value = withVaList(param) { (data) -> String in
            NSString(format: localizedString, locale: NSLocale.current, arguments: data) as String
        }
        return value
    }
    
    static func localized(key: String, tableName: String? = nil, bundle: Bundle = .main, value: String = "", comment: String = "", param: CVarArg...) -> String {
        let localizedString = NSLocalizedString(key, tableName: tableName, bundle: bundle, value: value, comment: comment)
        let value = withVaList(param) { (data) -> String in
            NSString(format: localizedString, locale: NSLocale.current, arguments: data) as String
        }
        return value
    }
}

//swiftlint:disable:next type_body_length
enum LocalizedKey: Localizable {

    case appName
    case ok
    case cancel
    case delete
    case takePhoto
    case openGallery
    case setting
    case quantityIsZero
    case doYouWantToDeleteThisItem
    case productDetail
    case productDescription(String)
    case itemName
    case quantity
    case price
    case tax
    case enterPlaceholder(String)
    case addProductToCart
    case createItem
    case plaseAllowCameraAccess
    case isEmpty(String)
    case isInvalid(String)
    case error
    case item
    case total
    case grandTotal
    case continuePayment
    case userName
    case userAddress
    case yourOrders
    case cartEmpty
    case failedToFetchCartItems
    case english
    case hindi
    case selectLanguage
    case selectLanguageMessage(String)
    
    /// The key to fetch the corresponding localized string
    var key: String {
        switch self {
        case .appName: return "APP_NAME"
        case .ok: return "OK"
        case .cancel: return "CANCEL"
        case .delete: return "DELETE"
        case .takePhoto: return "TAKE_PHOTO"
        case .openGallery: return "OPEN_GALLERY"
        case .setting: return "SETTING"
        case .quantityIsZero: return "QUANTITY_IS_ZERO"
        case .doYouWantToDeleteThisItem: return "DO_YOU_WANT_TO_DELETE_THIS_ITEM"
        case .productDetail: return "PRODUCT_DETAIL"
        case .productDescription: return "PRODUCT_DESCRIPTION"
        case .itemName: return "ITEM_NAME"
        case .quantity: return "PRICE"
        case .price: return "QUANTITY"
        case .tax: return "TAX"
        case .enterPlaceholder: return "ENTER_PLACEHOLDER"
        case .addProductToCart: return "ADD_PRODUCT_TO_THE_CART"
        case .createItem: return "CREATE_ITEM"
        case .plaseAllowCameraAccess: return "PLEASE_ALLOW_CAMERA_ACCESS"
        case .isEmpty: return "IS_EMPTY"
        case .isInvalid: return "IS_VALID"
        case .error: return "ERROR"
        case .item: return "ITEM"
        case .total: return "TOTAL"
        case .grandTotal: return "GRAND_TOTAL"
        case .continuePayment: return "CONTINUE_PAYMENT"
        case .userName: return "USER_NAME"
        case .userAddress: return "USER_ADDRESS"
        case .yourOrders: return "YOUR_ORDERS"
        case .cartEmpty: return "NO_ITEMS_IN_CART"
        case .failedToFetchCartItems: return "FAILED_TO_FETCH_CART_ITEMS"
        case .english: return "ENGLISH"
        case .hindi: return "HINDI"
        case .selectLanguage: return "SELECT_LANGUAGE"
        case .selectLanguageMessage: return "SELECTION_MESSAGE"
        }
    }
    
    var value: String {
        switch self {
        case .isEmpty(let param), .isInvalid(let param), .productDescription(let param), .enterPlaceholder(let param), .selectLanguageMessage(let param):
            return Localizer.localized(key: self, param: param)
        default:
            return Localizer.localized(key: self)
        }
    }
}
