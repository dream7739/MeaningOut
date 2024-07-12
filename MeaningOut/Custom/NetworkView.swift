//
//  NetworkView.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/22/24.
//

import UIKit

final class NetworkView: UIView {
    private let networkImage = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    let retryButton = UIButton()
    
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

extension NetworkView: BaseProtocol {
    func configureHierarchy(){
        addSubview(networkImage)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(retryButton)
    }
    
    func configureLayout(){
        networkImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(networkImage.snp.bottom).offset(10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.centerX.equalTo(networkImage)
        }
        
        retryButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
        }
    }
    
    func configureUI(){
        backgroundColor = .white
        
        networkImage.image = ImageType.wifi
        networkImage.tintColor = ColorType.tertiary
        
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.textColor = ColorType.primary
        titleLabel.textAlignment = .center
        titleLabel.text = "네트워크 연결이 원할하지 않습니다"
        
        descriptionLabel.font = FontType.tertiary
        descriptionLabel.textColor = ColorType.secondary
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 2
        descriptionLabel.text = "네트워크 연결 상태를 확인하고\n다시 시도해 주세요"
        
        retryButton.layer.cornerRadius = 20
        retryButton.backgroundColor = ColorType.black
        retryButton.setTitleColor(ColorType.white, for: .normal)
        retryButton.setTitle("다시 시도", for: .normal)

    }
}
