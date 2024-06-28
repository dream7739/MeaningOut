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
            case profile_9
            case profile_10
            case profile_11

            static var randomTitle: String {
                return ProfileType.allCases.randomElement()!.rawValue
            }

        }
    }
    
    
}
