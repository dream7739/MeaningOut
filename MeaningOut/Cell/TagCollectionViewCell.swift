//
//  TagCollectionViewCell.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/15/24.
//

import UIKit
import SnapKit

class TagCollectionViewCell: UICollectionViewCell {
    let tagLabel = PaddingLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension TagCollectionViewCell: BaseProtocol {
    func configureHierarchy() {
        contentView.addSubview(tagLabel)
    }
    
    func configureLayout() {
        tagLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        tagLabel.textColor = Constant.ColorType.black
        tagLabel.font = Constant.FontType.secondary
        tagLabel.textAlignment = .center
    }
}
