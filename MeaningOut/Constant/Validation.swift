//
//  ValidationError.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/22/24.
//

import Foundation

enum Validation {
    enum Nickname: Error {
        case countLimit
        case isEmpty
        case isSpecialChar
        case isNumber
        
        var description: String {
            switch self {
            case .countLimit:
                return "2글자 이상 10글자 미만으로 설정주세요"
            case .isEmpty:
                return "닉네임을 입력해주세요"
            case .isSpecialChar:
                return "닉네임에 @, #, $, %는 포함할 수 없어요"
            case .isNumber:
                return "닉네임에 숫자는 포함할 수 없어요"
            }
        }
    }
    
    enum Network: Error {
        case failedRequest
        case noData
        case invalidResponse
        case invalidData
        case invalidURL
    }
    
    enum Web: String, Error {
        case failNavigation = "웹페이지를 불러올 수 없습니다."
        case failLoad = "컨텐츠를 가져올 수 없습니다."
        case invalidURL = "웹페이지 주소가 유효하지 않습니다."
    }
}
