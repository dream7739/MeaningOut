//
//  Like.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/6/24.
//

import Foundation
import RealmSwift

class Like: Object {
    @Persisted(primaryKey: true) var productId: Int
    @Persisted(indexed: true) var title: String
    @Persisted var link: String
    @Persisted var image: String
    @Persisted var lprice: String
    @Persisted var mallName: String
    @Persisted var regDate: Date
    
    convenience init(productId: Int, title: String, link: String, image: String, lprice: String, mallName: String) {
        self.init()
        self.productId = productId
        self.title = title
        self.link = link
        self.image = image
        self.lprice = lprice
        self.mallName = mallName
        self.regDate = Date()
    }
}
