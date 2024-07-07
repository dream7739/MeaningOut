//
//  TagCollectionViewCell.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/15/24.
//

import UIKit
import SnapKit

final class TagCollectionViewCell: UICollectionViewCell {
    
    private let tagLabel = PaddingLabel()
    
    var isClicked: Bool = false{
        didSet {
            if isClicked {
                tagLabel.backgroundColor = Design.ColorType.black
                tagLabel.textColor = Design.ColorType.white
            }else{
                tagLabel.backgroundColor = Design.ColorType.white
                tagLabel.textColor = Design.ColorType.primary
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

extension TagCollectionViewCell {
    func configureData(_ data: Display.SortOption){
        tagLabel.text = data.title
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
        tagLabel.textColor = Design.ColorType.black
        tagLabel.font = Design.FontType.secondary
        tagLabel.textAlignment = .center
        tagLabel.clipsToBounds = true
    }
}
