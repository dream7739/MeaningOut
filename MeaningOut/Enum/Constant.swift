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
        static let empty = UIImage(named: "empty")
        
        enum ProfileType:String, CaseIterable {
            case profile_0
            case profile_1
            case profile_2
            case profile_3
            case profile_4
            case profile_5
            case profile_6
            case profile_7
            case profile_8
            case profile_9
            case profile_10
            case profile_11


            static let profileList: [UIImage] = [UIImage(named: Constant.ImageType.ProfileType.profile_0.rawValue)!,
                                                 UIImage(named: Constant.ImageType.ProfileType.profile_1.rawValue)!,
                                                 UIImage(named: Constant.ImageType.ProfileType.profile_2.rawValue)!,
                                                 UIImage(named: Constant.ImageType.ProfileType.profile_3.rawValue)!,
                                                 UIImage(named: Constant.ImageType.ProfileType.profile_4.rawValue)!,
                                                 UIImage(named: Constant.ImageType.ProfileType.profile_5.rawValue)!,
                                                 UIImage(named: Constant.ImageType.ProfileType.profile_6.rawValue)!,
                                                 UIImage(named: Constant.ImageType.ProfileType.profile_7.rawValue)!,
                                                 UIImage(named: Constant.ImageType.ProfileType.profile_8.rawValue)!,
                                                 UIImage(named: Constant.ImageType.ProfileType.profile_9.rawValue)!,
                                                 UIImage(named: Constant.ImageType.ProfileType.profile_10.rawValue)!,
                                                 UIImage(named: Constant.ImageType.ProfileType.profile_11.rawValue)! ]
            
            static var randomTitle: String {
                return ProfileType.allCases.randomElement()!.rawValue
            }

        }
    }
    
    
    enum RoundImageType {
        case regular
        case highlight
    }
    
    enum TagType: Int, CaseIterable {
        case accurate = 0
        case date = 1
        case priceasc = 2
        case priceDesc = 3
        
        var title: String {
            switch self {
            case .accurate:
                return "정확도"
            case .date:
                return "날짜순"
            case .priceasc:
                return "가격높은순"
            case .priceDesc:
                return "가격낮은순"
            }
        }
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
        case search = "브랜드, 상품 등을 입력하세요"
    }
    
    enum ViewType {
        case nickname
        case profile
        case search
        case result
        case detail
        case setting

        var navigationTitle: String {
            switch self {
            case .nickname, .profile:
                return "PROFILE SETTING"
            case .search:
                return "\(UserManager.nickname)`s MEANING OUT"
            case .result, .detail:
                return ""
            case .setting:
                return "SETTING"
            }
        }
        
 
    }
}
