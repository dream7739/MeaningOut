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
    let totalDescription: String
    
    enum CodingKeys: CodingKey {
        case total
        case start
        case display
        case items
    }

    init(total: Int, start:Int, display: Int, items: [Shop]){
        self.total = total
        self.start = start
        self.display = display
        self.items = items
        self.totalDescription = "\(total.formatted())개의 검색 결과"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.total = try container.decode(Int.self, forKey: .total)
        self.start = try container.decode(Int.self, forKey: .start)
        self.display = try container.decode(Int.self, forKey: .display)
        self.items = try container.decode([Shop].self, forKey: .items)
        self.totalDescription =  "\(total.formatted())개의 검색 결과"
    }
}

struct Shop: Decodable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
    let productId: String
    let titleDescription: String
    let priceDescription: String
    
    enum CodingKeys: CodingKey {
        case title
        case link
        case image
        case lprice
        case mallName
        case productId
    }
    
    init(title: String, link: String, image: String, lprice:String, mallName: String, productId: String){
        self.title = title
        self.link = link
        self.image = image
        self.lprice = lprice
        self.mallName = mallName
        self.productId = productId
        self.titleDescription = title.htmlToString() ?? title
        if let price = Int(self.lprice) {
            self.priceDescription = price.formatted() + "원"
        }else{
            self.priceDescription = lprice + "원"
        }
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.link = try container.decode(String.self, forKey: .link)
        self.image = try container.decode(String.self, forKey: .image)
        self.lprice = try container.decode(String.self, forKey: .lprice)
        self.mallName = try container.decode(String.self, forKey: .mallName)
        self.productId = try container.decode(String.self, forKey: .productId)
        self.titleDescription = title.htmlToString() ?? title
        if let price = Int(self.lprice) {
            self.priceDescription = price.formatted() + "원"
        }else{
            self.priceDescription = lprice + "원"
        }
    }
    
 
}
