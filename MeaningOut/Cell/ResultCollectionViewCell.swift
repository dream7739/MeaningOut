//
//  ResultCollectionViewCell.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/15/24.
//

import UIKit
import Kingfisher
import RealmSwift
import SnapKit

final class ResultCollectionViewCell: UICollectionViewCell {
    
    private let itemImage = UIImageView()
    private let companyLabel = UILabel()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let likeView = UIView()
    private let likeImage = UIImageView()
    private let likeButton = UIButton()
    
    private let repository = RealmRepository()
    var keyword: String?
    var indexPath: IndexPath?
    var isClicked: Bool = false {
        didSet {
            if isClicked {
                likeView.backgroundColor = Design.ColorType.white
                likeImage.image = Design.ImageType.like_selected
            }else{
                likeView.backgroundColor = Design.ColorType.black.withAlphaComponent(0.3)
                likeImage.image = Design.ImageType.like_unselected
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureUI()
        likeButton.addTarget(
            self,
            action: #selector(likeButtonClicked),
            for: .touchUpInside
        )
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
        
        if let keyword {
            nameLabel.attributedText = data.titleDescription.highLightKeyword(keyword)
        }else{
            nameLabel.text = data.titleDescription
        }
        
        priceLabel.text = data.priceDescription
        
        if repository.isExistLike(id: Int(data.productId)!){
            isClicked = true
        }else{
            isClicked = false
        }
    }
    
    func cancelDownload(){
        itemImage.kf.cancelDownloadTask()
    }
    
    @objc 
    func likeButtonClicked(){
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
        
        companyLabel.font = Design.FontType.quaternary
        companyLabel.textColor = Design.ColorType.secondary
        
        nameLabel.font = Design.FontType.tertiary
        nameLabel.textColor = Design.ColorType.black
        nameLabel.numberOfLines = 2
        
        priceLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        priceLabel.textColor = Design.ColorType.black
        
        likeView.backgroundColor = Design.ColorType.black.withAlphaComponent(0.3)
        likeView.layer.cornerRadius = 7
        
        likeImage.image = Design.ImageType.like_unselected
        
        likeButton.backgroundColor = .clear
    }
    
    
}


