//
//  SettingTableViewCell.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/16/24.
//

import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {
    
    let nameLabel = UILabel()
    
    let likeImage = UIImageView()
    
    let countLabel = UILabel()

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
    func configureData(_ data: Constant.SettingType){
        nameLabel.text = data.title
        
        if data == .cart {
            let countText = "\(UserManager.likeList.count)개의 상품"
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
        nameLabel.textColor = Constant.ColorType.black
        nameLabel.font = Constant.FontType.secondary
        
        likeImage.image = Constant.ImageType.like_selected
    
        countLabel.textColor = Constant.ColorType.black
        countLabel.font = Constant.FontType.tertiary
    }
}
