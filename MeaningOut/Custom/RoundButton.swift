//
//  RoundButton.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/13/24.
//

import UIKit

class RoundButton: UIButton {
    init(buttonType: Constant.ButtonType){
        super.init(frame: .zero)
        setTitle(buttonType.rawValue, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = Constant.ColorType.theme
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
