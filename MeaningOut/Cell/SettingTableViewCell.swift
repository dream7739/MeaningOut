//
//  SettingTableViewCell.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/16/24.
//

import UIKit
import SnapKit

final class SettingTableViewCell: UITableViewCell {
    
    private let nameLabel = UILabel()
    private let likeImage = UIImageView()
    private let countLabel = UILabel()
    
    private let repository = RealmRepository()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SettingTableViewCell {
    func configureData(_ data: Display.Setting){
        nameLabel.text = data.title
        
        if data == .cart {
            let countText = "\(repository.fetchAll().count)개의 상품"
            countLabel.text = countText
            
            let font = UIFont.boldSystemFont(ofSize: 14)
            let attributedStr = NSMutableAttributedString(string: countText)
            
            let idx = countText.firstIndex(of: "개")!
            let range  = NSRange(countText.startIndex...idx, in: countText)
            
            attributedStr.addAttribute(.font, value: font, range: range)
            countLabel.attributedText = attributedStr
            
            likeImage.isHidden = false
            countLabel.isHidden = false
        }else{
            likeImage.isHidden = true
            countLabel.isHidden = true
        }
    }
}

extension SettingTableViewCell: BaseProtocol {
    func configureHierarchy() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(likeImage)
        contentView.addSubview(countLabel)
    }
    
    func configureLayout() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        likeImage.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(countLabel.snp.leading).offset(-5)
        }
        
        countLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            
        }
    }
    
    func configureUI() {
        nameLabel.textColor = Design.ColorType.black
        nameLabel.font = Design.FontType.secondary
        
        likeImage.image = Design.ImageType.like_selected
        likeImage.tintColor = Design.ColorType.theme
    
        countLabel.textColor = Design.ColorType.black
        countLabel.font = Design.FontType.tertiary
    }
}

