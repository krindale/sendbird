//
//  ImageCaches.swift
//  Sendbird
//
//  Created by 이해상 on 2021/09/27.
//

import UIKit

// Image Cache
struct ImageCache {
    static var shared = ImageCache()
    
    private var cacheDictionary: [String: Data?] = [:]
    
    private init() {}
    
    // Store Image
    mutating func store(isbn13: String, image: UIImage) {
        UserDefaults.imageCache[isbn13] = image.pngData()
    }
    
    // Get Image
    func getImage(isbn13: String) -> UIImage? {
        guard let imageData = UserDefaults.imageCache[isbn13] else { return nil }

        if let data = imageData {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
}
