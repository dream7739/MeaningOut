//
//  PaddingLabel.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/15/24.
//

import UIKit

final class TagButton: UIButton {
    
    var isClicked: Bool = false{
        didSet {
            if isClicked {
                backgroundColor = ColorType.black
                tintColor = ColorType.white
            }else{
                backgroundColor = ColorType.white
                tintColor = ColorType.primary
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = ColorType.tertiary.cgColor
        tintColor = ColorType.primary
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

