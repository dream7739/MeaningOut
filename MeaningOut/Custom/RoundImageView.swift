//
//  RoundImageView.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit

class RoundImageView: UIImageView {
    
    init(imageType: Constant.RoundImageType){
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        configureUI(imageType)
    }
    
    func configureUI(_ imageType: Constant.RoundImageType){
        switch imageType {
        case .regular:
            layer.borderWidth = 1
            layer.borderColor = Constant.ColorType.tertiary.cgColor
            alpha = 0.5
        case .highlight:
            layer.borderWidth = 3
            layer.borderColor = Constant.ColorType.theme.cgColor
            alpha = 1.0
        }
    }
    
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
