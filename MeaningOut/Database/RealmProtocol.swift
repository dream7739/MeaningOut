//
//  RealmProtocol.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/6/24.
//

import Foundation
import RealmSwift

//CRUD
protocol RealmProtocol {
    func addLike(_ item: Like)
    func fetchAll() -> Results<Like>
    func fetchAllCount() -> Int
    func deleteLike(_ id: Int)
    func isExistLike(id: Int) -> Bool
}
