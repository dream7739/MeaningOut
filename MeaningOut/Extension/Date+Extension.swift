//
//  Date+Extension.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/17/24.
//

import Foundation

extension Date{
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
}
