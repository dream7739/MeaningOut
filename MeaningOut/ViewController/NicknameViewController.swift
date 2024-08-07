//
//  NicknameView.swift
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        switch viewModel.viewType {
        case .add:
            configureNav(NavigationTitle.profile)
        case .edit:
            configureNav(NavigationTitle.editProfile)
        }
        
        configureHierarchy()
        configureLayout()
        bindData()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nicknameField.becomeFirstResponder()
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
        print("NicknameVC init")
    }
    
    deinit {
        print("NicknameVC Deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NicknameViewController {
    private func bindData(){
        
        viewModel.inputViewDidLoadTrigger.value = ()
        
        viewModel.outputNicknameText.bind { [weak self] value in
            self?.validLabel.text = value
        }
        
        viewModel.outputNicknameValid.bind { [weak self] value in
            if value {
                self?.nicknameField.setLineColor(type: .valid)
                self?.validLabel.textColor = ColorType.black
            }else{
                self?.nicknameField.setLineColor(type: .inValid)
                self?.validLabel.textColor = ColorType.theme
            }
        }
        
        viewModel.outputSaveButton.bind { [weak self] _ in
            if let type = self?.viewModel.viewType {
                switch type {
                case .add:
                    self?.transitionScene(ShopTabBarController())
                case .edit:
                    if self != nil {
                        self!.transition(self!, .pop)
                    }
                }
            }
            
        }
    }
    
    @objc
    private func profileImageClicked(){
        let vc = ProfileViewController()
        vc.profileImageSender = { [weak self] profile in
            self?.viewModel.profileImage = profile
            self?.profileView.profileImage.image = UIImage(named: profile ?? "")
        }
        vc.viewType = viewModel.viewType
        vc.profileImage = viewModel.profileImage
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
        if let profileImage = viewModel.profileImage {
            profileView.profileImage.image = UIImage(named: profileImage)
        }
        
        switch viewModel.viewType {
        case .add:
            nicknameField.text = ""
        case .edit:
            addSaveBarButton()
            viewModel.inputNickname.value = UserManager.nickname
            nicknameField.text = UserManager.nickname
            completeButton.isHidden = true
        }
        
        nicknameField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameField.clearButtonMode = .whileEditing
        validLabel.font = FontType.tertiary
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
