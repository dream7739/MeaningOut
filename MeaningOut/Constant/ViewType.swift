//
//  Navigation.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/9/24.
//

import Foundation

enum ViewType{
    case onboard
    case nickname(_ type: ViewDetailType)
    case profile(_ type: ViewDetailType)
    case search
    case result(_ title: String)
    case like
    case detail(_ title: String)
    case setting
    
    enum ViewDetailType {
        case add
        case edit
    }

    var title: String {
        switch self {
        case .nickname(.add), .profile(.add):
            return "PROFILE SETTING"
        case .search:
            return "\(UserManager.nickname)`s MEANING OUT"
        case .onboard:
            return ""
        case .result(let title), .detail(let title):
            return title
        case .setting:
            return "SETTING"
        case .nickname(.edit), .profile(.edit):
            return "EDIT PROFILE"
        case .like:
            return "LIKED PRODUCTS"
        }
    }
    
    var detail: ViewDetailType {
        switch self {
        case .nickname(let type), .profile(let type):
            return type
        default:
            return .add
        }
    }
    
}

