//
//  Constant.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/13/24.
//

import UIKit

enum Design {
    static let serviceName = "MeaningOut"
    
    enum ColorType {
        static let theme = UIColor(red: 242/255, green: 109/255, blue: 233/255, alpha: 1)
        static let subTheme = UIColor(red: 242/255, green: 179/255, blue: 238/255, alpha: 1)
        static let primary = UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1)
        static let secondary = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)
        static let tertiary = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        static let black = UIColor.black
        static let white = UIColor.white
    }
    
    enum FontType {
        static let gmarketBold = UIFont(name: "GmarketSansBold", size: 44)
        static let gmarketMedium = UIFont(name: "GmarketSansMedium", size: 15)
        static let gmarketLight = UIFont(name: "GmarketSansLight", size: 12)
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
        static let wifi = UIImage(systemName: "wifi")
        
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

            static var randomTitle: String {
                return ProfileType.allCases.randomElement()!.rawValue
            }

        }
    }
    
    
}
