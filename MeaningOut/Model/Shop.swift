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
    let items: [Shop]
}

struct Shop: Decodable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
    let productId: String
}
