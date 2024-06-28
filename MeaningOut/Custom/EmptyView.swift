//
//  EmptyView.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/15/24.
//

import UIKit
import SnapKit

class EmptyView: UIView {
    
    let emptyImage = UIImageView()
    let descriptionLabel = UILabel()
    
    init(type: EmptyView.EmptyType) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        configureUI()
        setDescription(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDescription(_ type: EmptyView.EmptyType){
        descriptionLabel.text = type.rawValue
    }
}

extension EmptyView{
    enum EmptyType: String{
        case search = "최근 검색어가 없어요"
        case result = "검색 결과가 없어요"
        case link = "해당 상품의 페이지가 존재하지 않습니다"
    }
}

extension EmptyView: BaseProtocol {
    func configureHierarchy(){
        addSubview(emptyImage)
        addSubview(descriptionLabel)
    }
    
    func configureLayout(){
        emptyImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(emptyImage.snp.bottom).offset(10)
            make.centerX.equalTo(emptyImage)
        }
    }
    
    func configureUI(){
        backgroundColor = .white
        
        emptyImage.image = Design.ImageType.empty
        
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        descriptionLabel.textAlignment = .center
    }
}
