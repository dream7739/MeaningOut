//
//  UserDefaultsManager.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import Foundation

@propertyWrapper
struct UserDefaultsManager<T: Codable> {
    let defaultValue: T
    let key: String
    let storage: UserDefaults
    
    var wrappedValue: T {
        get{
            if let data = self.storage.object(forKey: key) as? Data {
                if let decodeData = try? JSONDecoder().decode(T.self, from: data){
                    return decodeData
                }
            }
            
            return defaultValue
        }
        set{
            if let data = try? JSONEncoder().encode(newValue) {
                self.storage.set(data, forKey: key)
            }
        }
    }
}

class UserManager {
    private init(){}
    
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
        defaultValue: "",
        key: "joinDate",
        storage: .standard
    )
    static var joinDate: String
    
    @UserDefaultsManager(
        defaultValue: [],
        key: "savedList",
        storage: .standard
    )
    static var savedList: [String]
    
    static var recentList: [String] = []
    
    @UserDefaultsManager(
        defaultValue: [],
        key: "likeSet",
        storage: .standard
    )
    static var likeSet: Set<String>
    
    static func addLikeList(_ productId: String){
        if !UserManager.likeSet.contains(productId){
            UserManager.likeSet.insert(productId)
        }
    }
    
    static func removeLikeList(_ productId: String){
        if UserManager.likeSet.contains(productId){
            UserManager.likeSet.remove(productId)
        }
    }
    
    static func resetAll(){
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}
