//
//  APIRequest.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/27/24.
//

import Foundation

enum APIRequest{
    case shop(request: ShopRequest)
    
    var method: String {
        switch self {
        case .shop:
            return "GET"
        }
    }
    
    var baseURL: String {
        return APIURL.naver
    }

    var endPoint: String {
        switch self {
        case .shop:
            return "search/shop.json"
        }
    }
    
    var header: [String: String] {
        return [
            "X-Naver-Client-Id" : APIKey.clientID,
            "X-Naver-Client-Secret": APIKey.clientSecret]
    }
    
    var param: [String: String] {
        switch self {
        case .shop(let request):
            return [
                "query" : request.query,
                "start": "\(request.start)",
                "display": "\(request.display)",
                "sort": request.sort
            ]
        }
    }
    
}
