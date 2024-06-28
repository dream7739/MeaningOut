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
    
    let likeView = UIView()
    
    let likeImage = UIImageView()
    
    let likeButton = UIButton()
    
    var indexPath: IndexPath?
    
    var isClicked: Bool = false {
        didSet {
            if isClicked {
                likeView.backgroundColor = Constant.ColorType.white
                likeImage.image = Constant.ImageType.like_selected
            }else{
                likeView.backgroundColor = Constant.ColorType.black.withAlphaComponent(0.3)
                likeImage.image = Constant.ImageType.like_unselected
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureUI()
        likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ResultCollectionViewCell {
    func configureData(_ data: Shop){
        itemImage.kf.indicatorType = .activity
        itemImage.kf.setImage(with: URL(string: data.image))
        companyLabel.text = data.mallName
        nameLabel.text = data.titleDescription
        priceLabel.text = data.priceDescription
        
        if let _ = UserManager.likeDict[data.productId], !UserManager.likeDict.isEmpty {
            isClicked = true
        }else{
            isClicked = false
        }
    }
    
    func cancelDownload(){
        itemImage.kf.cancelDownloadTask()
    }
    
    @objc func likeButtonClicked(){
        guard let indexPath else { return }
        
        isClicked.toggle()

        let info: [String: (IndexPath, Bool)] = [
            ShopNotificationKey.indexPath: (indexPath, isClicked)
        ]

        NotificationCenter.default.post(
            name: ShopNotification.like,
            object: nil,
            userInfo: info
        )
    }
}

extension ResultCollectionViewCell: BaseProtocol {
    func configureHierarchy() {
        contentView.addSubview(itemImage)
        contentView.addSubview(companyLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeView)
        likeView.addSubview(likeImage)
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
        
        likeView.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(itemImage).inset(15)
            make.size.equalTo(30)
        }
        
        likeImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(20)
        }
        
        likeButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(itemImage)
            make.size.equalTo(50)
        }
    }
    
    func configureUI() {
        itemImage.backgroundColor = .gray
        itemImage.layer.cornerRadius = 10
        itemImage.clipsToBounds = true
        itemImage.contentMode = .scaleAspectFill
        
        companyLabel.font = Constant.FontType.quaternary
        companyLabel.textColor = Constant.ColorType.tertiary
        
        nameLabel.font = Constant.FontType.tertiary
        nameLabel.textColor = Constant.ColorType.black
        nameLabel.numberOfLines = 2
        
        priceLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        priceLabel.textColor = Constant.ColorType.black
        
        likeView.backgroundColor = Constant.ColorType.black.withAlphaComponent(0.3)
        likeView.layer.cornerRadius = 7
        
        likeImage.image = Constant.ImageType.like_unselected
        
        likeButton.backgroundColor = .clear
    }
    
    
}


