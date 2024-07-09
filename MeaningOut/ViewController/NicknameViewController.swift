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
    
    private let viewModel = NicknameViewModel()
    var viewType: ViewType!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(viewType)
        configureHierarchy()
        configureLayout()
        configureUI()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let image =  viewModel.inputProfileImage.value {
            profileView.profileImage.image = UIImage(named: image)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nicknameField.becomeFirstResponder()
    }
}

extension NicknameViewController {
    func bindData(){
        viewModel.inputViewDidLoadTrigger.value = ()
        
        viewModel.inputViewType.value = viewType.detail
        
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
        
        viewModel.outputSaveButton.bind { value in
            guard let _ = value else { return }
            switch self.viewType.detail {
            case .add:
                let vc = ShopTabBarController()
                self.transitionScene(vc)
            case .edit:
                self.transition(self, .pop)
            }
        }
    }
    
    @objc
    private func profileImageClicked(){
        let vc = ProfileViewController()
        
        vc.profileDataSender = { profile in
            guard let image = profile else { return }
            self.viewModel.inputProfileImage.value = image
        }
        
        vc.viewType = .profile(viewType.detail)
        vc.selectedProfile = viewModel.inputProfileImage.value
        vc.selectedProfile = viewModel.inputProfileImage.value
        transition(vc, .push)
    }
    
    @objc
    private func textFieldChanged(){
        viewModel.inputNickname.value = nicknameField.text!.trimmingCharacters(in: .whitespaces)
    }
    
    @objc
    private func completeButtonClicked(){
        viewModel.inputSaveButton.value = ()
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
        switch viewType.detail {
        case .add:
            nicknameField.text = ""
        case .edit:
            viewModel.inputNickname.value = UserManager.nickname
            addSaveBarButton()
            nicknameField.text = UserManager.nickname
            completeButton.isHidden = true
        }
        
        if let image = viewModel.inputProfileImage.value {
            profileView.profileImage.image = UIImage(named: image)
        }
        
        nicknameField.placeholder = Display.Placeholder.nickname.rawValue
        nicknameField.clearButtonMode = .whileEditing
        
        validLabel.font = Design.FontType.tertiary
        validLabel.textColor = Design.ColorType.theme
        
        completeButton.setTitle("완료", for: .normal)
        
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
            action: #selector(completeButtonClicked),
            for: .editingDidEndOnExit
        )
        
        completeButton.addTarget(
            self,
            action: #selector(completeButtonClicked),
            for: .touchUpInside
        )
    }
    
    private func addSaveBarButton(){
        let save = UIBarButtonItem(
            title: "저장",
            style: .plain,
            target: self,
            action: #selector(completeButtonClicked)
        )
        save.tintColor = .black
        navigationItem.rightBarButtonItem = save
    }
}
