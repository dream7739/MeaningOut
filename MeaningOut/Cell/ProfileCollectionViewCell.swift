//
//  ProfileCollectionViewCell.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit
import SnapKit

final class ProfileCollectionViewCell: UICollectionViewCell {
    
    private let profileImage = RoundImageView(type: .regular)
        
    var isClicked = false {
        didSet{
            if isClicked {
                profileImage.setHighLight()
            }else{
                profileImage.setRegular()
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

extension ProfileCollectionViewCell {
    func configureData(data: Design.ProfileType){
        profileImage.image = UIImage(named: data.rawValue)
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
    
}
