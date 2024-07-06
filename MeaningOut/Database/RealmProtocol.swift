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
    //C: 신규로 Realm에 추가
    //R: DB에서 좋아요한 값을 읽어옴 fetch
    //D: 좋아요를 삭제하면, 해당 ID값으로 삭제
    
    func addLike(_ item: Like)
    func fetchAll() -> Results<Like>
    func deleteLike(_ id: Int)
    
}
