//
//  NicknameViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/13/24.
//

import UIKit
import SnapKit

class NicknameViewController: UIViewController {

    let profileImage = RoundImageView(imageType: .highlight)
    let cameraImage = UIImageView()
    let nicknameField = UnderLineTextField(viewType: .nickname)
    let validLabel = UILabel()
    let completeButton = RoundButton(viewType: .nickname)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(.nickname)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension NicknameViewController : BaseProtocol {
    func configureHierarchy() {
        view.addSubview(profileImage)
        view.addSubview(cameraImage)
        view.addSubview(nicknameField)
        view.addSubview(validLabel)
        view.addSubview(completeButton)
    }
    
    func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.size.equalTo(130)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        cameraImage.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.trailing.bottom.equalTo(profileImage).inset(5)
        }

        nicknameField.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        validLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(nicknameField)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(validLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(nicknameField)
            make.height.equalTo(44)
        }
    }
    
    func configureUI() {
        profileImage.image = UIImage(named: "profile_0")
        
        cameraImage.image = Constant.ImageType.photo
        cameraImage.contentMode = .center
        cameraImage.tintColor = .white
        cameraImage.backgroundColor = Constant.ColorType.theme
        cameraImage.layer.cornerRadius = 13
        cameraImage.clipsToBounds = true

        validLabel.font = Constant.FontType.tertiary
        validLabel.textColor = Constant.ColorType.theme
        validLabel.text = "닉네임에 @는 포함할 수 없어요"
    

    }
}
