//
//  NoteManager.swift
//  Sendbird
//
//  Created by 이해상 on 2021/10/04.
//

import Foundation

// Note Manager
struct NoteManager {
    static var shared = NoteManager()
    
    private init() {}
    
    // Store Note
    mutating func store(isbn13: String, note: String) {
        UserDefaults.userNote[isbn13] = note
    }
    
    // Get Note
    func getNote(isbn13: String) -> String? {
        return UserDefaults.userNote[isbn13] as? String
    }
}
