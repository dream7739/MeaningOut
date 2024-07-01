//
//  RoundImageView.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit

final class RoundImageView: UIImageView {
    
    init(type: RoundImageView.ImageType){
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        
        switch type {
            case .regular: setRegular()
            case .highlight: setHighLight()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRegular(){
        layer.borderWidth = 1
        layer.borderColor = Design.ColorType.tertiary.cgColor
        alpha = 0.5
    }
    
    func setHighLight(){
        layer.borderWidth = 3
        layer.borderColor = Design.ColorType.theme.cgColor
        alpha = 1.0
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.width / 2
    }
    
}

extension RoundImageView {
    enum ImageType {
        case regular
        case highlight
    }
}
