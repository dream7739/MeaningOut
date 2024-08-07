//
//  RoundButton.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/13/24.
//

import UIKit

final class RoundButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(.white, for: .normal)
        backgroundColor = ColorType.theme
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
