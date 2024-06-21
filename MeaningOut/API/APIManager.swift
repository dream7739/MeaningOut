//
//  APIManager.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/21/24.
//

import Foundation
import Alamofire

class APIManager {
    private init(){ }
    
    static let shared = APIManager()
    
    func callNaverShop(req: ShopRequest,
                       completion: @escaping (Result<ShopResult, Error>) -> ()){
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.clientID,
            "X-Naver-Client-Secret": APIKey.clientSecret]
        
        let param: Parameters = [
            "query" : req.query,
            "start": req.start,
            "display": req.display,
            "sort": req.sort
        ]
        
        AF.request(
            APIURL.naverURL,
            method: .get,
            parameters: param,
            encoding: URLEncoding.queryString,
            headers: header
        ).responseDecodable(of: ShopResult.self, completionHandler: {
            response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
