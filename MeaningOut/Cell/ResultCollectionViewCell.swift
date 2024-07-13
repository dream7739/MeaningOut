//
//  ResultCollectionViewCell.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/15/24.
//

import UIKit
import Kingfisher
import SnapKit

protocol ResultLikeDelegate {
    func likeButtonClicked(_ indexPath: IndexPath, _ isClicked: Bool)
}

final class ResultCollectionViewCell: UICollectionViewCell {
    
    private let itemImage = UIImageView()
    private let companyLabel = UILabel()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let likeView = UIView()
    private let likeImage = UIImageView()
    private let likeButton = UIButton()
    
    var delegate: ResultLikeDelegate?
    var keyword: String?
    var indexPath: IndexPath?
    var isClicked: Bool = false {
        didSet {
            if isClicked {
                likeImage.image = ImageType.like_selected
            }else{
                likeView.backgroundColor = ColorType.black.withAlphaComponent(0.3)
                likeImage.image = ImageType.like_unselected
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
    }
    
    func cancelDownload(){
        itemImage.kf.cancelDownloadTask()
    }
    
    @objc 
    func likeButtonClicked(){
        guard let indexPath else { return }
        
        isClicked.toggle()
        
        delegate?.likeButtonClicked(indexPath, isClicked)

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
            make.bottom.trailing.equalTo(itemImage).inset(10)
            make.size.equalTo(30)
        }
        
        likeImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(23)
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
        
        companyLabel.font = FontType.quaternary
        companyLabel.textColor = ColorType.secondary
        
        nameLabel.font = FontType.tertiary
        nameLabel.textColor = ColorType.black
        nameLabel.numberOfLines = 2
        
        priceLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        priceLabel.textColor = ColorType.black
        
        likeView.backgroundColor = ColorType.black.withAlphaComponent(0.3)
        likeView.layer.cornerRadius = 7
        
        likeImage.image = ImageType.like_unselected
        likeImage.tintColor = ColorType.white
        
        likeButton.backgroundColor = .clear
    }
    
    
}


