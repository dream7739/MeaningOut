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
    
    func validateUserInput() throws -> Bool {
        guard !self.isEmpty else{
            throw Constant.ValidationError.isEmpty
        }
        
        guard self.count >= 2 && self.count <= 10 else {
            throw Constant.ValidationError.countLimit
        }
        
        guard (self.range(of:  #"[@#$%]"#, options: .regularExpression) == nil) else {
            throw Constant.ValidationError.isSpecialChar
        }
        
        guard (self.range(of: #"[0-9]"#, options: .regularExpression) == nil) else {
            throw Constant.ValidationError.isNumber
        }
        
        return true
    }
    

}
