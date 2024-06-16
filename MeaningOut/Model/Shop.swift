//
//  Shop.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/15/24.
//

import Foundation

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
        return title.htmlToAttributedString()?.string ?? title
    }
    
    var priceDescription: String {
        guard let price = Int(lprice) else{
            return lprice + "원"
        }
        
        return price.formatted() + "원"
    }

}
