//
//  PaddingLabel.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/15/24.
//

import UIKit

final class PaddingLabel: UILabel {
    let topInset: CGFloat = 8
    let bottomInset: CGFloat = 8
    let leftInset: CGFloat = 10.0
    let rightInset: CGFloat = 10.0
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = ColorType.tertiary.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let inset = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: inset))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }
}

