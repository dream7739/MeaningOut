//
//  Display.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/27/24.
//

import Foundation

enum Display {
    enum SettingType: Int, CaseIterable {
        case cart = 0
        case questition = 1
        case voc
        case noti
        case reset
        
        var title: String {
            switch self {
            case .cart:
                return "나의 장바구니 목록"
            case .questition:
                return "자주 묻는 질문"
            case .voc:
                return "1:1 문의"
            case .noti:
                return "알림 설정"
            case .reset:
                return "탈퇴하기"
            }
        }
    }
    
    enum PlaceholderType: String {
        case nickname = "닉네임을 입력해주세요 :)"
        case search = "브랜드, 상품 등을 입력하세요"
    }
    
    enum SortType: Int, CaseIterable {
        case sim = 0
        case date = 1
        case dsc = 2
        case asc = 3
        
        var title: String {
            switch self {
            case .sim:
                return "정확도"
            case .date:
                return "날짜순"
            case .dsc:
                return "가격높은순"
            case .asc:
                return "가격낮은순"
            }
        }
        
        var sortParam: String {
            return String(describing: self)
        }
    }
}
