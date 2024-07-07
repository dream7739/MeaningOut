//
//  RealmProtocol.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/6/24.
//

import Foundation
import RealmSwift

protocol RealmProtocol {
    func addLike(_ item: Like)
    func fetchAll() -> Results<Like>
    func fetchAll(_ keyword: String) -> Results<Like>
    func deleteLike(_ id: Int)
    func deleteLike(_ item: Like)
    func isExistLike(id: Int) -> Bool
}

protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}
