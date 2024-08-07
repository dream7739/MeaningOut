//
//  RealmRepository.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/6/24.
//

import Foundation
import RealmSwift

final class RealmRepository: RealmProtocol {
    
    private let realm = try! Realm()
    
    func addLike(_ item: Like) {
        do{
            try realm.write {
                realm.add(item)
            }
        }catch{
            print("AddLike Failed")
        }
    }
    
    func fetchAll() -> Results<Like> {
        return realm.objects(Like.self).sorted(byKeyPath: "regDate", ascending: false)
    }
    
    func fetchAll(_ keyword: String) -> Results<Like> {
        return realm.objects(Like.self).where {
            $0.title.contains(keyword, options: .caseInsensitive)
        }.sorted(byKeyPath: "regDate", ascending: false)
    }
    
    func deleteAll() {
        do{
            try realm.write {
                realm.deleteAll()
            }
        }catch{
            print("deleteAll Failed")
        }
    }
    
    func deleteLike(_ id: Int) {
        if let item = realm.object(ofType: Like.self, forPrimaryKey: id){
            do{
                try realm.write {
                    realm.delete(item)
                }
            }catch{
                print("deleLike Failed")
            }
        }
    }
    
    func deleteLike(_ item: Like) {
        do{
            try realm.write {
                realm.delete(item)
            }
        }catch{
            print("deleLike Failed")
        }
    }
    
    func isExistLike(id: Int) -> Bool{
        if let _ = realm.object(ofType: Like.self, forPrimaryKey: id){
            return true
        }else{
            return false
        }
    }
}
