//
//  Shop.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/15/24.
//

import Foundation

struct ShopRequest {
    var query: String
    var start: Int
    var display: Int
    var sort: String
}

struct ShopResult: Decodable {
    let total: Int
    let start: Int
    let display: Int
    var items: [Shop]
    
    var totalDescription: String {
        return "\(total.formatted())개의 검색 결과"
    }
}

struct Shop: Decodable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
    let productId: String
    
    var titleDescription: String {
        return title.htmlToString() ?? title
    }
    
    var priceDescription: String {
        if let price = Int(self.lprice) {
            return price.formatted() + "원"
        }else{
           return lprice + "원"
        }
    }
   
}

extension Shop : Persistable {
    typealias ManagedObject = Like

    //Like -> Shop
    init(managedObject: Like) {
        title = managedObject.title
        link = managedObject.link
        image = managedObject.image
        lprice = managedObject.lprice
        mallName = managedObject.mallName
        productId = "\(managedObject.productId)"
    }
    
    //Shop -> Like
    func managedObject() -> Like {
        let like = Like(productId: Int(productId)!, title: title, link: link, image: image, lprice: lprice, mallName: mallName)
        return like
    }
}
