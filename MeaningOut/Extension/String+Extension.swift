//
//  String+Extension.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import Foundation

extension String {
    func htmlToAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else { return nil }
        
        return attributedString
    }
    
    func isValid(regexType: Constant.RegexType) -> Bool {
        switch regexType{
        case .countRegex:
            if self.count < 2 || self.count > 10 {
                return false
            }else{
                return true
            }
        case .specialcharRegex:
            guard let _ = self.range(of: regexType.rawValue, options: .regularExpression) else {
                return true
            }
            return false
        case .numberRegex:
            guard let _ = self.range(of: regexType.rawValue, options: .regularExpression) else {
                return true
            }
            return false
        }
        
    }
    
 
}
