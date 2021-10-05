//
//  UIImageView+Extension.swift
//  Sendbird
//
//  Created by 이해상 on 2021/10/04.
//

import UIKit

extension UIImageView {
    // Image From URL
    func imageFromUrl(isbn13: String, url: String) {
        self.image = nil
        
        // Default Thread
        DispatchQueue.global().async {
            // Get Image from Url
            guard let imageURL = URL(string: url),
                let data = try? Data(contentsOf: imageURL) else { return }
            // Main Thread
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.image = image
                    self.contentMode = .scaleAspectFit
                    // Store to Image Caches
                    ImageCache.shared.store(isbn13: isbn13, image: image)
                }
            }
        }
    }
}
