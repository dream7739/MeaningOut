//
//  SearchTableViewCell.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/15/24.
//

import UIKit
import SnapKit

class SearchTableViewCell: UITableViewCell {

    let timeImage = UIImageView()
    
    let recentLabel = UILabel()
    
    let deleteButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configureData(_ data: String){
        recentLabel.text = data
    }
    
}

extension SearchTableViewCell: BaseProtocol {
    func configureHierarchy() {
        contentView.addSubview(timeImage)
        contentView.addSubview(recentLabel)
        contentView.addSubview(deleteButton)
    }
    
    func configureLayout() {
        timeImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(13)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(20)
        }
        
        recentLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeImage.snp.trailing).offset(15)
            make.trailing.equalTo(deleteButton.snp.leading).offset(-15)
            make.centerY.equalTo(timeImage)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(recentLabel)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(20)
        }
    }
    
    func configureUI() {
        timeImage.image = Constant.ImageType.time
        timeImage.tintColor = Constant.ColorType.black
        
        recentLabel.font = Constant.FontType.tertiary
        recentLabel.numberOfLines = 1
        recentLabel.textColor = Constant.ColorType.black
        
        deleteButton.setImage(Constant.ImageType.close, for: .normal)
        deleteButton.setTitleColor(Constant.ColorType.black, for: .normal) 
        deleteButton.tintColor = Constant.ColorType.black
    }
}
