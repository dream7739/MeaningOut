//
//  ResultCollectionViewCell.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/15/24.
//

import UIKit
import SnapKit

class ResultCollectionViewCell: UICollectionViewCell {
    let itemImage = UIImageView()
    
    let companyLabel = UILabel()
    
    let nameLabel = UILabel()
    
    let priceLabel = UILabel()
    
    let likeButton = UIButton()
    
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

extension ResultCollectionViewCell: BaseProtocol {
    func configureHierarchy() {
        contentView.addSubview(itemImage)
        contentView.addSubview(companyLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeButton)
    }
    
    func configureLayout() {
        itemImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.75)
        }
        
        companyLabel.snp.makeConstraints { make in
            make.top.equalTo(itemImage.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(companyLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(itemImage).inset(15)
            make.size.equalTo(20)
        }
    }
    
    func configureUI() {
        itemImage.backgroundColor = .gray
        itemImage.layer.cornerRadius = 10
        itemImage.clipsToBounds = true
        
        companyLabel.font = Constant.FontType.tertiary
        companyLabel.textColor = Constant.ColorType.tertiary
        companyLabel.text = "네이버"
        
        nameLabel.font = Constant.FontType.primary
        nameLabel.textColor = Constant.ColorType.black
        nameLabel.text = "아이폰 프로 256G"
        nameLabel.numberOfLines = 2
        
        priceLabel.font = Constant.FontType.primary
        priceLabel.textColor = Constant.ColorType.black
        priceLabel.text = "15600원"
        
        likeButton.setBackgroundImage(UIImage(named: "like_unselected"), for: .normal)
    }
    
    
}

