//
//  UnderLineTextField.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit
import SnapKit

final class UnderLineTextField : UITextField {
    private let underline = UIView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = ColorType.theme
        textColor = ColorType.primary
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        underline.backgroundColor = ColorType.tertiary
        addSubview(underline)
        
        underline.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setLineColor(type: TextFieldType){
        switch type {
        case .normal:
            underline.backgroundColor = ColorType.tertiary
        case .valid:
            underline.backgroundColor = ColorType.black
        case .inValid:
            underline.backgroundColor = ColorType.theme
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
