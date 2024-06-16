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
    var viewType: Constant.ViewType =  .nickname
    var selectedProfileImage: String?
    
    override func viewWillAppear(_ animated: Bool) {
        if viewType == .nickname {
            nicknameField.text = ""
        }
        
        if let selectedProfileImage {
            profileView.profileImage.image = UIImage(named: selectedProfileImage)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(viewType)
        configureHierarchy()
        configureLayout()
        configureUI()
        
        if viewType == .editNickname {
            completeButton.isHidden = true
            addSaveButton()
            nicknameField.text = UserManager.nickname
            validCheck(UserManager.nickname)
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageClicked))
        profileView.addGestureRecognizer(tapRecognizer)
        
        nicknameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        
    }
    
    func addSaveButton(){
        let save = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(completeButtonClicked))
        navigationItem.rightBarButtonItem = save
    }
    
    func validCheck(_ input: String){
        if input.isEmpty {
            validLabel.text = ""
            isValid = false
            return
        }
        
        if !input.isValid(regexType: .countRegex){
            validLabel.text = Constant.ValidType.countResult.rawValue
            isValid = false
        }else if !input.isValid(regexType: .specialcharRegex){
            validLabel.text = Constant.ValidType.specialResult.rawValue
            isValid = false
        }else if !input.isValid(regexType: .numberRegex){
            validLabel.text = Constant.ValidType.numberResult.rawValue
            isValid = false
        }else{
            validLabel.text = Constant.ValidType.validResult.rawValue
            isValid = true
        }
    }
    
    func saveUserData(){
        if viewType == .nickname {
            UserManager.isUser = true
            UserManager.nickname = nicknameField.text!.trimmingCharacters(in: .whitespaces)
            
            if let image = selectedProfileImage {
                UserManager.profileImage = image
            }
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            let joinDate = dateFormatter.string(from: date)
            
            UserManager.joinDate = joinDate
            
        }else if viewType == .editNickname {
            UserManager.nickname = nicknameField.text!.trimmingCharacters(in: .whitespaces)
            
            if let image = selectedProfileImage {
                UserManager.profileImage = image
            }
        }
    }
    
    @objc func profileImageClicked(){
        let vc = ProfileViewController()
        
        vc.profileDataSender = { profile in
            guard let image = profile else { return }
            self.selectedProfileImage = image
        }
        
        vc.viewType = .editProfile
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textFieldChanged(){
        let input = nicknameField.text!.trimmingCharacters(in: .whitespaces)
        validCheck(input)
    }
    
    @objc func completeButtonClicked(){
        if isValid {
            
            saveUserData()
            
            if viewType == .nickname {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let tabBarController = TabBarController()
                sceneDelegate?.window?.rootViewController = tabBarController
                sceneDelegate?.window?.makeKeyAndVisible()
            }else if viewType == .editNickname {
                navigationController?.popViewController(animated: true)
            }
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

