//
//  ProfileCollectionViewCell.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit
import SnapKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    let profileImage = RoundImageView(imageType: .regular)
    
    var delegate: CellProtocol?
    
    var isClicked = false {
        didSet{
            if isClicked {
                profileImage.configureUI(.highlight)
            }else{
                profileImage.configureUI(.regular)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ProfileCollectionViewCell: BaseProtocol {
    func configureHierarchy() {
        contentView.addSubview(profileImage)
    }
    
    func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        
    }
    
}
