//
//  UserDefault+Extension.swift
//  Sendbird
//
//  Created by 이해상 on 2021/10/04.
//

import UIKit

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

extension UserDefaults {

    @UserDefault(key: "imageCache", defaultValue: [String: Data?]())
    static var imageCache: [String: Data?]

    @UserDefault(key: "searchTotal", defaultValue: [String: Data?]())
    static var searchTotal: [String: Data?]
    
    @UserDefault(key: "searchCache", defaultValue: [String: Data?]())
    static var searchCache: [String: Data?]

    @UserDefault(key: "userNote", defaultValue: [String: String?]())
    static var userNote: [String: String?]
}
