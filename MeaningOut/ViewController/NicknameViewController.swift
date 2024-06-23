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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(viewType)
        configureHierarchy()
        configureLayout()
        configureUI()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageClicked))
        profileView.addGestureRecognizer(tapRecognizer)
        
        nicknameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        nicknameField.addTarget(self, action: #selector(returnKeyClicked), for: .editingDidEndOnExit)
        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedProfileImage {
            profileView.profileImage.image = UIImage(named: selectedProfileImage)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            self.nicknameField.becomeFirstResponder()
    }
}

extension NicknameViewController {
    
    @discardableResult
    func validateUserInput(_ input: String) throws -> Bool {
        guard !input.isEmpty else{
            throw Validation.Nickname.isEmpty
        }
        
        guard input.count >= 2 && input.count <= 10 else {
            throw Validation.Nickname.countLimit
        }
        
        guard (input.range(of:  #"[@#$%]"#, options: .regularExpression) == nil) else {
            throw Validation.Nickname.isSpecialChar
        }
        
        guard (input.range(of: #"[0-9]"#, options: .regularExpression) == nil) else {
            throw Validation.Nickname.isNumber
        }
        
        return true
    }
    
    func checkUserInput(_ input: String){
        do {
            isValid = try validateUserInput(input)
            validLabel.text = "사용 가능한 닉네임입니다 :)"
            nicknameField.setLineColor(type: .valid)
            validLabel.textColor = Constant.ColorType.black
        }catch Validation.Nickname.isEmpty {
            isValid = false
            validLabel.text =  Validation.Nickname.isEmpty.description
            nicknameField.setLineColor(type: .inValid)
            validLabel.textColor = Constant.ColorType.theme
        }catch Validation.Nickname.countLimit {
            isValid = false
            validLabel.text = Validation.Nickname.countLimit.description
            nicknameField.setLineColor(type: .inValid)
            validLabel.textColor = Constant.ColorType.theme
        }catch Validation.Nickname.isNumber{
            isValid = false
            validLabel.text = Validation.Nickname.isNumber.description
            nicknameField.setLineColor(type: .inValid)
            validLabel.textColor = Constant.ColorType.theme
        }catch Validation.Nickname.isSpecialChar {
            isValid = false
            validLabel.text = Validation.Nickname.isSpecialChar.description
            nicknameField.setLineColor(type: .inValid)
            validLabel.textColor = Constant.ColorType.theme
        }catch {
            print("Etc error occured")
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
            let tabBarController = ShopTabBarController()
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
        checkUserInput(input)
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
        //진입 지점에 따른 분기 처리
        if viewType == .editNickname {
            nicknameField.text = UserManager.nickname
            completeButton.isHidden = true
            addSaveButton()
            checkUserInput(UserManager.nickname)
        }else if viewType == .nickname {
            nicknameField.text = ""
        }
        
        if UserManager.profileImage.isEmpty {
            selectedProfileImage = Constant.ImageType.ProfileType.randomTitle
        }else{
            selectedProfileImage = UserManager.profileImage
        }
        profileView.profileImage.image = UIImage(named: selectedProfileImage!)
        
        nicknameField.placeholder = Constant.PlaceholderType.nickname.rawValue
        nicknameField.clearButtonMode = .whileEditing
        
        validLabel.font = Constant.FontType.tertiary
        validLabel.textColor = Constant.ColorType.theme
        
        completeButton.setTitle("완료", for: .normal)
    }
    
    func addSaveButton(){
        let save = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(completeButtonClicked))
        save.tintColor = .black
        navigationItem.rightBarButtonItem = save
    }
}
