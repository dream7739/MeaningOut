//
//  Constant.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/13/24.
//

import UIKit

enum Constant {
    enum ColorType {
        static let theme = UIColor(red: 239/255, green: 137/255, blue: 71/255, alpha: 1)
        static let primary = UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1)
        static let secondary = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)
        static let tertiary = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1)
        static let black = UIColor.black
        static let white = UIColor.white
    }
    
    enum FontType {
        static let primary = UIFont.systemFont(ofSize: 16)
        static let secondary = UIFont.systemFont(ofSize: 15)
        static let tertiary = UIFont.systemFont(ofSize: 14)
        static let quaternary = UIFont.systemFont(ofSize: 13)
        
    }
    
    enum ImageType {
        static let start = UIImage(named: "launch")
        static let search = UIImage(systemName: "magnifyingglass")
        static let profile = UIImage(systemName: "person")
        static let next = UIImage(systemName: "chevron.right")
        static let back = UIImage(systemName: "chevron.left")
        static let time = UIImage(systemName: "clock")
        static let close = UIImage(systemName: "xmark")
        static let photo = UIImage(systemName: "camera.fill")
        
        enum ProfileType {
            static let profile_0 = UIImage(named: "profile_0")!
            static let profile_1 = UIImage(named: "profile_1")!
            static let profile_2 = UIImage(named: "profile_2")!
            static let profile_3 = UIImage(named: "profile_3")!
            static let profile_4 = UIImage(named: "profile_4")!
            static let profile_5 = UIImage(named: "profile_5")!
            static let profile_6 = UIImage(named: "profile_6")!
            static let profile_7 = UIImage(named: "profile_7")!
            static let profile_8 = UIImage(named: "profile_8")!
            static let profile_9 = UIImage(named: "profile_9")!
            static let profile_10 = UIImage(named: "profile_10")!
            static let profile_11 = UIImage(named: "profile_11")!
            
            static let profileList: [UIImage] = [Constant.ImageType.ProfileType.profile_0,
                                                 Constant.ImageType.ProfileType.profile_1,
                                                 Constant.ImageType.ProfileType.profile_2,
                                                 Constant.ImageType.ProfileType.profile_3,
                                                 Constant.ImageType.ProfileType.profile_4,
                                                 Constant.ImageType.ProfileType.profile_5,
                                                 Constant.ImageType.ProfileType.profile_6,
                                                 Constant.ImageType.ProfileType.profile_7,
                                                 Constant.ImageType.ProfileType.profile_8,
                                                 Constant.ImageType.ProfileType.profile_9,
                                                 Constant.ImageType.ProfileType.profile_10,
                                                 Constant.ImageType.ProfileType.profile_11]

        }
    }
    
    
    enum RoundImageType {
        case regular
        case highlight
    }
    
    enum RegexType: String {
        case countRegex
        case specialcharRegex = #"[@#$%]"#
        case numberRegex = #"[0-9]"#
    }
    
    enum ButtonType: String {
        case onboard =  "시작하기"
        case nickname = "완료"
    }
    
    enum PlaceholderType: String {
        case nickname = "닉네임을 입력해주세요 :)"
    }
    
    enum ViewType {
        case nickname
        case profile
        
        var navigationTitle: String {
            switch self {
            case .nickname, .profile:
                return "PROFILE SETTING"
            }
        }
        
 
    }
}
