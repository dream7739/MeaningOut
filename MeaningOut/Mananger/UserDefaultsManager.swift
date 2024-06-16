//
//  UserDefaultsManager.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import Foundation

@propertyWrapper
struct UserDefaultsManager<T> {
    let defaultValue: T
    let key: String
    let storage: UserDefaults
    
    var wrappedValue: T {
        get{
            self.storage.object(forKey: key) as? T ?? defaultValue
        }
        set{
            self.storage.set(newValue, forKey: key)
        }
    }
}

class UserManager {
    @UserDefaultsManager(
        defaultValue: false,
        key: "isUser",
        storage: .standard
    )
    static var isUser: Bool

    
    @UserDefaultsManager(
        defaultValue: "",
        key: "profile",
        storage: .standard
    )
    static var profileImage: String
    
    @UserDefaultsManager(
        defaultValue: "",
        key: "nickname",
        storage: .standard
    )
    static var nickname: String
    
    
    @UserDefaultsManager(
        defaultValue: [],
        key: "savedList",
        storage: .standard
    )
    static var savedList: [String]
    
    static var recentList: [String] = []
    
    @UserDefaultsManager(
        defaultValue: [],
        key: "likeList",
        storage: .standard
    )
    static var likeList: [String]
}
