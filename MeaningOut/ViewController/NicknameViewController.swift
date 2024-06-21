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
    let nicknameField = UnderLineTextField()
    let validLabel = UILabel()
    let completeButton = RoundButton()
    
    var viewType: Constant.ViewType =  .nickname
    var isValid = false
    var selectedProfileImage: String?
    
    
    override func viewWillAppear(_ animated: Bool) {
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
        }else if viewType == .nickname {
            nicknameField.text = ""
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageClicked))
        profileView.addGestureRecognizer(tapRecognizer)
        
        nicknameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        nicknameField.addTarget(self, action: #selector(returnKeyClicked), for: .editingDidEndOnExit)

        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            self.nicknameField.becomeFirstResponder()
    }
}

extension NicknameViewController {
    func addSaveButton(){
        let save = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(completeButtonClicked))
        save.tintColor = .black
        navigationItem.rightBarButtonItem = save
    }
    
    func validCheck(_ input: String){
        do {
            isValid = try input.validateUserInput()
            validLabel.text = Constant.RegexResult.validResult.rawValue
        }catch Constant.ValidationError.isEmpty {
            validLabel.text =  Constant.RegexResult.emptyResult.rawValue
            nicknameField.setLineColor(type: .normal)
            isValid = false
        }catch Constant.ValidationError.countLimit {
            validLabel.text = Constant.RegexResult.countResult.rawValue
            isValid = false
        }catch Constant.ValidationError.isNumber{
            validLabel.text = Constant.RegexResult.numberResult.rawValue
            isValid = false
        }catch Constant.ValidationError.isSpecialChar {
            validLabel.text = Constant.RegexResult.specialResult.rawValue
            isValid = false
        }catch {
            print("Etc error occured")
        }
        
        if isValid {
            nicknameField.setLineColor(type: .valid)
            validLabel.textColor = Constant.ColorType.black
        }else{
            nicknameField.setLineColor(type: .inValid)
            validLabel.textColor = Constant.ColorType.theme
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
            let joinDate = date.toString()
            UserManager.joinDate = joinDate
            
        }else if viewType == .editNickname {
            UserManager.nickname = nicknameField.text!.trimmingCharacters(in: .whitespaces)
            
            if let image = selectedProfileImage {
                UserManager.profileImage = image
            }
        }
    }
    
    func changeScreen(){
        if viewType == .nickname {
            let tabBarController = TabBarController()
            configureRootView(tabBarController)
        }else if viewType == .editNickname {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func profileImageClicked(){
        let vc = ProfileViewController()
        
        vc.profileDataSender = { profile in
            guard let image = profile else { return }
            self.selectedProfileImage = image
        }
        
        if viewType == .editNickname {
            vc.viewType = .editProfile
        }else if viewType == .nickname {
            vc.viewType = .profile
        }
        
        vc.selectedProfile = selectedProfileImage
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textFieldChanged(){
        let input = nicknameField.text!.trimmingCharacters(in: .whitespaces)
        validCheck(input)
    }
    
    @objc func returnKeyClicked(){
        completeButtonClicked()
    }
    
    @objc func completeButtonClicked(){
        if isValid {
            saveUserData()
            changeScreen()
        }
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
        nicknameField.placeholder = Constant.PlaceholderType.nickname.rawValue
        nicknameField.clearButtonMode = .whileEditing
        
        validLabel.font = Constant.FontType.tertiary
        validLabel.textColor = Constant.ColorType.theme
        
        if UserManager.profileImage.isEmpty {
            selectedProfileImage = Constant.ImageType.ProfileType.randomTitle
        }else{
            selectedProfileImage = UserManager.profileImage
        }
        
        profileView.profileImage.image = UIImage(named: selectedProfileImage!)

        completeButton.setTitle("완료", for: .normal)
    }
}
