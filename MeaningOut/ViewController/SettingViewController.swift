//
//  SettingViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit

final class SettingViewController: UIViewController {
    private let headerView = UIView()
    private let profileImage = RoundImageView(type: .highlight)
    private let nicknameLabel = UILabel()
    private let dateLabel = UILabel()
    private let indicatorImage = UIImageView()
    private let sepratorLabel = UILabel()
    private let tableView = UITableView()
    
    let viewModel = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(NavigationTitle.setting)
        configureHierarchy()
        configureLayout()
        configureUI()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileImage.image = UIImage(named: UserManager.profileImage)
        nicknameLabel.text = UserManager.nickname
        tableView.reloadRows(
            at: [IndexPath(row: 0, section: 0)],
            with: .none
        )
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
        print("SettingVC Init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("SettingVC Deinit")
    }
}

extension SettingViewController {
    enum SettingOption: Int, CaseIterable {
        case cart
        case questition
        case voc
        case noti
        case reset
        
        var title: String {
            switch self {
            case .cart:
                return "나의 장바구니 목록"
            case .questition:
                return "자주 묻는 질문"
            case .voc:
                return "1:1 문의"
            case .noti:
                return "알림 설정"
            case .reset:
                return "탈퇴하기"
            }
        }
    }
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.rowHeight = 48
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.isScrollEnabled = false
    }
    
    @objc
    private func headerViewClicked(){
        let nicknameVC = NicknameViewController()
        nicknameVC.viewModel.viewType = .edit
        transition(nicknameVC, .push)
    }
}

extension SettingViewController: BaseProtocol {
    func configureHierarchy() {
        view.addSubview(headerView)
        headerView.addSubview(profileImage)
        headerView.addSubview(nicknameLabel)
        headerView.addSubview(dateLabel)
        headerView.addSubview(indicatorImage)
        headerView.addSubview(sepratorLabel)
        
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        headerView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(150)
        }
        
        profileImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.size.equalTo(100)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.centerY.equalToSuperview().offset(-10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            make.leading.equalTo(nicknameLabel)
        }
        
        indicatorImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(18)
            make.height.equalTo(25)
            
        }
        
        sepratorLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        profileImage.image = UIImage(named: UserManager.profileImage)
        
        nicknameLabel.font = .systemFont(ofSize: 16, weight: .heavy)
        nicknameLabel.textColor = ColorType.black
        nicknameLabel.text = UserManager.nickname
        
        dateLabel.font = FontType.tertiary
        dateLabel.textColor = ColorType.secondary
        dateLabel.text = UserManager.joinDate + " 가입"
        
        indicatorImage.image = ImageType.next
        indicatorImage.tintColor = ColorType.secondary
        
        sepratorLabel.backgroundColor = ColorType.tertiary
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(headerViewClicked)
        )
        
        headerView.addGestureRecognizer(tapGesture)
        
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
        let data = SettingOption.allCases[indexPath.row]
        cell.selectionStyle = .none
        cell.configureData(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            showAlert("탈퇴하기", "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?") {[weak self] _ in
                self?.viewModel.inputLeaveClicked.value = ()
                let onboardingViewController = UINavigationController(rootViewController: OnboardingViewController())
                self?.transitionScene(onboardingViewController)
            }
        }
    }
}

