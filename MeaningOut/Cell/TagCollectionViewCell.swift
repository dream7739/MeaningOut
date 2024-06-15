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
    
    var delegate: CellProtocol?
    
    var isClicked: Bool = false{
        didSet {
            if isClicked {
                tagLabel.backgroundColor = Constant.ColorType.primary
                tagLabel.textColor = Constant.ColorType.white
            }else{
                tagLabel.backgroundColor = Constant.ColorType.white
                tagLabel.textColor = Constant.ColorType.primary
            }
        }
    }
    
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
        tagLabel.clipsToBounds = true
    }
}
