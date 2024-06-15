//
//  ResultCollectionViewCell.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/15/24.
//

import UIKit
import Kingfisher
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
    
    func configureData(_ data: Shop){
        itemImage.kf.setImage(with: URL(string: data.image))
        companyLabel.text = data.mallName
        nameLabel.text = data.title
        priceLabel.text = Int(data.lprice)!.formatted(.number) + "원"
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
        itemImage.contentMode = .scaleAspectFill
        
        companyLabel.font = Constant.FontType.tertiary
        companyLabel.textColor = Constant.ColorType.tertiary
        
        nameLabel.font = Constant.FontType.secondary
        nameLabel.textColor = Constant.ColorType.black
        nameLabel.numberOfLines = 2
        
        priceLabel.font = Constant.FontType.secondary
        priceLabel.textColor = Constant.ColorType.black
        
        likeButton.setBackgroundImage(UIImage(named: "like_unselected"), for: .normal)
    }
    
    
}


