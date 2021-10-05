//
//  SearchCaches.swift
//  Sendbird
//
//  Created by 이해상 on 2021/09/30.
//

import Foundation

// Search Result Cache Key
struct SearchCacheKey: Hashable, Codable {
    var searchText: String
    var page: Int
}

// Search Result Cache
struct SearchCaches {
    
    static var shared = SearchCaches()
    
    private init() {}
    
    // Store Book Search Model
    mutating func store(key: SearchCacheKey, model: BookSearchModel) {
        guard let keyData = try? JSONEncoder().encode(key),
              let searchBooks = try? JSONEncoder().encode(model) else { return }
        UserDefaults.searchCache[keyData.base64EncodedString()] = searchBooks
    }
    
    // Get Book Search Model
    func getResponse(key: SearchCacheKey) -> BookSearchModel? {
        guard let keyData = try? JSONEncoder().encode(key) else { return nil }

        if let data = UserDefaults.searchCache[keyData.base64EncodedString()] as? Data {
            return try? JSONDecoder().decode(BookSearchModel.self, from: data)
        } else {
            return nil
        }
    }
}

