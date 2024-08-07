//
//  SearchTableViewCell.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/15/24.
//

import UIKit
import SnapKit

protocol SearchDeleteDelegate: AnyObject {
    func deleteButtonClicked(_ indexPath: IndexPath)
}

final class SearchTableViewCell: UITableViewCell {

    private let timeImage = UIImageView()
    private let recentLabel = UILabel()
    private let deleteButton = UIButton()
    private let deleteImage = UIImageView()
    
    weak var delegate: SearchDeleteDelegate?
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
    
    @objc
    func deleteButtonClicked(){
        guard let indexPath else { return }
        delegate?.deleteButtonClicked(indexPath)
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
        timeImage.image = ImageType.time
        timeImage.tintColor = ColorType.black
        
        recentLabel.font = FontType.tertiary
        recentLabel.numberOfLines = 1
        recentLabel.textColor = ColorType.black
        
        deleteButton.setTitleColor(ColorType.black, for: .normal)
        deleteButton.tintColor = ColorType.black
        
        deleteImage.image = ImageType.close
        deleteImage.contentMode = .scaleAspectFill

    }
}
