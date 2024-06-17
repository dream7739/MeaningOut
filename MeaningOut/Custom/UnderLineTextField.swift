//
//  UnderLineTextField.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit
import SnapKit

class UnderLineTextField : UITextField {
    let underline = UIView(frame: .zero)

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
        underline.backgroundColor = Constant.ColorType.tertiary
        addSubview(underline)
        
        underline.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setLine(type: Constant.TextFieldType){
        switch type {
        case .normal:
            underline.backgroundColor = Constant.ColorType.tertiary
        case .success:
            underline.backgroundColor = Constant.ColorType.black
        case .error:
            underline.backgroundColor = Constant.ColorType.theme
        }
    }
    
    
}
