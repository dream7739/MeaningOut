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
}
