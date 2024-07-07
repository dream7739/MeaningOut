//
//  Date+Extension.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/17/24.
//

import Foundation

enum DateFormat: String {
    case yyyyMMdd = "yyyy.MM.dd"
}

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.yyyyMMdd.rawValue
        return dateFormatter
    }()
}

extension Date{
    func toString() -> String {
        let dateStr = DateFormatter.dateFormatter.string(from: self)
        return dateStr
    }
}
