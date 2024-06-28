//
//  APIManager.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/21/24.
//

import Foundation

class APIManager {
    private init(){ }
    
    static let shared = APIManager()
    
    func request<T: Decodable>(model: T.Type, request: APIRequest,
                               completion: @escaping (Result<T, Validation.Network>) -> Void){
        
        guard var component = URLComponents(string: request.baseURL + request.endPoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let queryItems = request.param.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        component.queryItems = queryItems
        
        guard let url = component.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method
        urlRequest.allHTTPHeaderFields = request.header
        
        URLSession.shared.executeTask(urlRequest){
            data, response, error in
            DispatchQueue.main.async {
                
                guard error == nil else {
                    completion(.failure(.failedRequest))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                guard response.statusCode == 200 else {
                    completion(.failure(.invalidData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                }catch {
                    completion(.failure(.invalidData))
                }
            }
        }
    }
}

