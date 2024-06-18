//
//  Constant.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/13/24.
//

import UIKit

enum Constant {
    static let serviceName = "MeaningOut"
    
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
        static let like_unselected = UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal)
        static let like_selected = UIImage(named: "like_selected")?.withRenderingMode(.alwaysOriginal)
        
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

            static var randomTitle: String {
                return ProfileType.allCases.randomElement()!.rawValue
            }

        }
    }
    
    enum RoundImageType {
        case regular
        case highlight
    }
    
    enum TextFieldType {
        case normal
        case success
        case error
    }
    
    enum EmptyType: String{
        case search = "최근 검색어가 없어요"
        case result = "검색 결과가 없어요"
        case link = "해당 상품의 페이지가 존재하지 않습니다"
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
    
    enum ValidationError: Error {
        case countLimit
        case isEmpty
        case isSpecialChar
        case isNumber
    }
    
    enum RegexResult: String {
        case countResult = "2글자 이상 10글자 미만으로 설정주세요"
        case emptyResult = "닉네임을 입력해주세요"
        case specialResult = "닉네임에 @, #, $, %는 포함할 수 없어요"
        case numberResult = "닉네임에 숫자는 포함할 수 없어요"
        case validResult = "사용 가능한 닉네임입니다 :)"
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
        case editNickname
        case editProfile

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
            case .editNickname, .editProfile:
                return "EDIT PROFILE"
            }
        }
        
 
    }
}
