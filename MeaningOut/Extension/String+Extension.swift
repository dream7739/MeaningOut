//
//  String+Extension.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import Foundation

extension String {
    func htmlToString() -> String? {
        guard let data = self.data(using: .utf8) else { return nil }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else { return nil }
        
        return attributedString.string
    }
    
    func highLightKeyword(_ keyword: String) -> NSMutableAttributedString{
        let range = (self as NSString).range(of: keyword)
        let attributedString = NSMutableAttributedString(string: self)
        
        attributedString.addAttributes([
            .backgroundColor : ColorType.subTheme.withAlphaComponent(0.5)],
            range: range
        )
       
        return attributedString
    }
    
}
