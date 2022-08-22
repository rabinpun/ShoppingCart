//
//  ImageManager.swift
//  ShoppingCart
//
//  Created by ebpearls on 21/08/2022.
//

import Foundation
import UIKit

protocol ImageManagable {
    func saveImage(_ image: UIImage, name: String) throws
    func getImage(name: String) throws -> UIImage?
    func deleteImage(name: String)
}

struct ImageManagerError: LocalizedError {}

final class ImageManager: ImageManagable {
    
    private let fileManager = FileManager.default
    private let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    
    private var imageCache = [String: UIImage]()
    
    func saveImage(_ image: UIImage, name: String) throws {
        imageCache[name] = image
        let fileURL = documentsDirectory.appendingPathComponent(name)
        if let data = image.jpegData(compressionQuality: 1.0) {
            try data.write(to: fileURL)
        } else {
            throw ImageManagerError()
        }
    }
    
    func getImage(name: String) throws -> UIImage? {
        guard InitialItem(rawValue: name) == nil else { return UIImage(named: name) }
        if let image = imageCache[name] {
            return image
        }
        let filePath = documentsDirectory.appendingPathComponent(name)
        guard fileManager.fileExists(atPath: filePath.relativePath), let image = UIImage(contentsOfFile: filePath.relativePath) else { return nil }
        imageCache[name] = image
        return image
    }
    
    func deleteImage(name: String) {
        do {
            try fileManager.removeItem(atPath: documentsDirectory.appendingPathComponent(name).path)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
}
