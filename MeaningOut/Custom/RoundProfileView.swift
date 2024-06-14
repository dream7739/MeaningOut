//
//  RoundProfileView.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit
import SnapKit

class RoundProfileView: UIView {
    let profileImage = RoundImageView(imageType: .highlight)
    let cameraImage = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy(){
        addSubview(profileImage)
        addSubview(cameraImage)
    }
    
    func configureLayout(){
        profileImage.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        cameraImage.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.trailing.bottom.equalTo(profileImage).inset(5)
        }
    }
    
    func configureUI(){
        if UserManager.profileImage.isEmpty {
            profileImage.image = UIImage(named: Constant.ImageType.ProfileType.randomTitle)!
        }else{
            profileImage.image = UIImage(named: UserManager.profileImage)
        } 

        cameraImage.image = Constant.ImageType.photo
        cameraImage.contentMode = .center
        cameraImage.tintColor = .white
        cameraImage.backgroundColor = Constant.ColorType.theme
        cameraImage.layer.cornerRadius = 13
        cameraImage.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.width / 2
    }
    
}
