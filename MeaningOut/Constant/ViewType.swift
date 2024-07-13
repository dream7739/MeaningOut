//
//  Navigation.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/9/24.
//

import Foundation

enum NavigationTitle {
    static let search = "\(UserManager.nickname)`s MEANING OUT"
    static let setting = "SETTING"
    static let like = "LIKED PRODUCTS"
    static let profile = "PROFILE SETTING"
    static let editProfile = "EDIT PROFILE"
}

enum ViewType{
    case add
    case edit
}
