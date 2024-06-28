//
//  URLSession+Extension.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/28/24.
//

import Foundation

extension URLSession {
    typealias completion = (Data?, URLResponse?, Error?) -> Void

    @discardableResult
    func executeTask(_ request: URLRequest, completion: @escaping completion) -> URLSessionDataTask {
        let task = dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}
