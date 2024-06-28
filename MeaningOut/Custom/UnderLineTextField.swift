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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = Design.ColorType.theme
        textColor = Design.ColorType.primary
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        underline.backgroundColor = Design.ColorType.tertiary
        addSubview(underline)
        
        underline.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setLineColor(type: UnderLineTextField.TextFieldType){
        switch type {
        case .normal:
            underline.backgroundColor = Design.ColorType.tertiary
        case .valid:
            underline.backgroundColor = Design.ColorType.black
        case .inValid:
            underline.backgroundColor = Design.ColorType.theme
        }
    }
    
}

extension UnderLineTextField {
    enum TextFieldType {
        case normal
        case valid
        case inValid
    }
}
