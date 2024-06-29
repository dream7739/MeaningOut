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
    let deleteImage = UIImageView()
        
    var indexPath: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureUI()
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}

extension SearchTableViewCell {
    func configureData(_ data: String){
        recentLabel.text = data
    }
    
    @objc func deleteButtonClicked(){
        guard let indexPath else { return }
        NotificationCenter.default.post(
            name: ShopNotification.delete,
            object: nil,
            userInfo: [ShopNotificationKey.indexPath : indexPath]
        )
    }
}

extension SearchTableViewCell: BaseProtocol {
    func configureHierarchy() {
        contentView.addSubview(timeImage)
        contentView.addSubview(recentLabel)
        contentView.addSubview(deleteButton)
        deleteButton.addSubview(deleteImage)
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
            make.trailing.equalToSuperview().inset(7.5)
            make.height.equalToSuperview()
            make.width.equalTo(40)
        }
        
        deleteImage.snp.makeConstraints { make in
            make.size.equalTo(15)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    func configureUI() {
        timeImage.image = Design.ImageType.time
        timeImage.tintColor = Design.ColorType.black
        
        recentLabel.font = Design.FontType.tertiary
        recentLabel.numberOfLines = 1
        recentLabel.textColor = Design.ColorType.black
        
        deleteButton.setTitleColor(Design.ColorType.black, for: .normal)
        deleteButton.tintColor = Design.ColorType.black
        
        deleteImage.image = Design.ImageType.close
        deleteImage.contentMode = .scaleAspectFill

    }
}
