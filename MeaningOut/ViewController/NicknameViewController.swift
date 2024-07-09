//
//  NicknameViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/13/24.
//

import UIKit
import SnapKit

final class NicknameViewController: UIViewController {
    
    private let profileView = RoundProfileView()
    private let nicknameField = UnderLineTextField()
    private let validLabel = UILabel()
    private let completeButton = RoundButton()
    
    let viewModel = NicknameViewModel()
    var viewType: ViewType =  .nickname
    var isValid = false
    var selectedProfileImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(viewType)
        configureHierarchy()
        configureLayout()
        configureUI()
        bindData()
        
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(profileImageClicked)
        )
        profileView.addGestureRecognizer(tapRecognizer)
        
        nicknameField.addTarget(
            self,
            action: #selector(textFieldChanged),
            for: .editingChanged
        )
        
        nicknameField.addTarget(
            self,
            action: #selector(returnKeyClicked),
            for: .editingDidEndOnExit
        )
        
        completeButton.addTarget(
            self,
            action: #selector(completeButtonClicked),
            for: .touchUpInside
        )
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
    func bindData(){
        viewModel.outputNicknameText.bind { value in
            self.validLabel.text = value
        }
        
        viewModel.outputNicknameValid.bind { value in
            if value {
                self.nicknameField.setLineColor(type: .valid)
                self.validLabel.textColor = Design.ColorType.black
            }else{
                self.nicknameField.setLineColor(type: .inValid)
                self.validLabel.textColor = Design.ColorType.theme
            }
        }
    }
    
   
    
    private func saveUserData(){
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
    
    private func changeScreen(){
        if viewType == .nickname {
            let tabBarController = ShopTabBarController()
            configureRootView(tabBarController)
        }else if viewType == .editNickname {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc
    private func profileImageClicked(){
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
    
    @objc
    private func textFieldChanged(){
        viewModel.inputNickname.value = nicknameField.text!.trimmingCharacters(in: .whitespaces)
        let input = nicknameField.text!.trimmingCharacters(in: .whitespaces)
    }
    
    @objc
    private func returnKeyClicked(){
        completeButtonClicked()
    }
    
    @objc
    private func completeButtonClicked(){
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
            viewModel.inputNickname.value = UserManager.nickname
        }else if viewType == .nickname {
            nicknameField.text = ""
        }
        
        if UserManager.profileImage.isEmpty {
            selectedProfileImage = Design.ImageType.ProfileType.randomTitle
        }else{
            selectedProfileImage = UserManager.profileImage
        }
        profileView.profileImage.image = UIImage(named: selectedProfileImage!)
        
        nicknameField.placeholder = Display.Placeholder.nickname.rawValue
        nicknameField.clearButtonMode = .whileEditing
        
        validLabel.font = Design.FontType.tertiary
        validLabel.textColor = Design.ColorType.theme
        
        completeButton.setTitle("완료", for: .normal)
    }
    
    private func addSaveButton(){
        let save = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(completeButtonClicked))
        save.tintColor = .black
        navigationItem.rightBarButtonItem = save
    }
}
