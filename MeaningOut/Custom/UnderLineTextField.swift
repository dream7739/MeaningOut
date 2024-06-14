//
//  UnderLineTextField.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit
import SnapKit

class UnderLineTextField : UITextField {
    init(placeholderType : Constant.PlaceholderType){
        super.init(frame: .zero)
        placeholder = placeholderType.rawValue
        tintColor = Constant.ColorType.theme
        textColor = Constant.ColorType.primary
        
        addUnderline()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addUnderline(){
        let underline = UIView(frame: .zero)
        underline.backgroundColor = Constant.ColorType.tertiary
        addSubview(underline)
        
        underline.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    
}
