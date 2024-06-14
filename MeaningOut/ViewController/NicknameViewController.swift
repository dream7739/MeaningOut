//
//  NicknameViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/13/24.
//

import UIKit
import SnapKit

class NicknameViewController: UIViewController {
    
    let profileView = RoundProfileView()
    let nicknameField = UnderLineTextField(placeholderType: .nickname)
    let validLabel = UILabel()
    let completeButton = RoundButton(buttonType: .nickname)
    
    var isValid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(.nickname)
        configureHierarchy()
        configureLayout()
        configureUI()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageClicked))
        profileView.addGestureRecognizer(tapRecognizer)
        
        nicknameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
    }
    
    @objc func profileImageClicked(){
        //프로필 화면으로 이동
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textFieldChanged(){
        let input = nicknameField.text!.trimmingCharacters(in: .whitespaces)
        
        if input.isEmpty {
            validLabel.text = ""
            isValid = false
            return
        }
        
        if !input.isValid(regexType: .countRegex){
            validLabel.text = "2글자 이상 10글자 미만으로 설정주세요"
            isValid = false
        }else if !input.isValid(regexType: .specialcharRegex){
            validLabel.text = "닉네임에 @, #, $, %는 포함할 수 없어요"
            isValid = false
        }else if !input.isValid(regexType: .numberRegex){
            validLabel.text = "닉네임에 숫자는 포함할 수 없어요"
            isValid = false
        }else{
            validLabel.text = "사용할 수 있는 닉네임이에요"
            isValid = true
        }
    }
    
    @objc func completeButtonClicked(){
        if isValid {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate

            let tabBarController = TabBarController()
            sceneDelegate?.window?.rootViewController = tabBarController
            sceneDelegate?.window?.makeKeyAndVisible()
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension NicknameViewController: BaseProtocol {
    func configureHierarchy() {
        view.addSubview(profileView)
        view.addSubview(nicknameField)
        view.addSubview(validLabel)
        view.addSubview(completeButton)
    }
    
    func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.size.equalTo(140)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        nicknameField.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(24)
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
        nicknameField.clearButtonMode = .whileEditing

        validLabel.font = Constant.FontType.tertiary
        validLabel.textColor = Constant.ColorType.theme
    }
}

