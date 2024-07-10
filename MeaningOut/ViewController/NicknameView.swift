//
//  NicknameViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/13/24.
//

import UIKit
import SnapKit

final class NicknameView: UIViewController {
    
    private let profileView = RoundProfileView()
    private let nicknameField = UnderLineTextField()
    private let validLabel = UILabel()
    private let completeButton = RoundButton()
    
    private let viewModel = NicknameViewModel()
    var viewType: ViewType!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(self, #function)
        configureView()
        configureNav(viewType)
        configureHierarchy()
        configureLayout()
        configureUI()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nicknameField.becomeFirstResponder()
    }
}

extension NicknameViewController {
    func bindData(){
        viewModel.inputViewType.value = viewType.detail
        
        viewModel.outputProfileImage.bind { value in
            if let value {
                self.profileView.profileImage.image = UIImage(named: value)
            }
        }
        
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
        
        viewModel.outputSaveButton.bind { _ in
            switch self.viewType.detail {
            case .add:
                let vc = ShopTabBarController()
                self.transitionScene(vc)
            case .edit:
                self.transition(self, .pop)
            }
        }
        
        viewModel.inputViewDidLoadTrigger.value = ()

    }
    
    @objc
    private func profileImageClicked(){
        let vc = ProfileViewController()
        
        vc.profileDataSender = { profile in
            self.viewModel.outputProfileImage.value = profile
        }
        
        vc.viewType = .profile(viewType.detail)
        vc.selectedProfile = viewModel.outputProfileImage.value
        vc.selectedProfile = viewModel.outputProfileImage.value
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
            addSaveBarButton()
            viewModel.inputNickname.value = UserManager.nickname
            nicknameField.text = UserManager.nickname
            completeButton.isHidden = true
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
