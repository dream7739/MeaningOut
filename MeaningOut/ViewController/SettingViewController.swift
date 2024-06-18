//
//  SettingViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit

class SettingViewController: UIViewController {
    
    let headerView = UIView()
    
    let profileImage = RoundImageView(type: .highlight)
    
    let nicknameLabel = UILabel()
    
    let dateLabel = UILabel()
    
    let indicatorImage = UIImageView()
    
    let sepratorLabel = UILabel()
    
    let tableView = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        profileImage.image = UIImage(named: UserManager.profileImage)
        nicknameLabel.text = UserManager.nickname
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(.setting)
        configureHierarchy()
        configureLayout()
        configureUI()
        configureTableView()
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerViewClicked))
        headerView.addGestureRecognizer(tapGesture)
    }
    
}



extension SettingViewController {
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        tableView.rowHeight = 48
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.isScrollEnabled = false
    }
    
    @objc func headerViewClicked(){
        let vc = NicknameViewController()
        vc.viewType = .editNickname
        navigationController?.pushViewController(vc, animated: true)
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
        nicknameLabel.textColor = Constant.ColorType.black
        nicknameLabel.text = UserManager.nickname
        
        dateLabel.font = Constant.FontType.tertiary
        dateLabel.textColor = Constant.ColorType.secondary
        dateLabel.text = UserManager.joinDate + " 가입"
        
        indicatorImage.image = Constant.ImageType.next
        indicatorImage.tintColor = Constant.ColorType.secondary
        
        sepratorLabel.backgroundColor = Constant.ColorType.tertiary
        
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.SettingType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell
        let data = Constant.SettingType.allCases[indexPath.row]
        cell.selectionStyle = .none
        cell.configureData(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            
            let alert = UIAlertController(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default) { _ in
                UserManager.resetAll()
                
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let vc = UINavigationController(rootViewController: OnboardingViewController())
                sceneDelegate?.window?.rootViewController = vc
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(confirm)
            alert.addAction(cancel)
            
            present(alert, animated: true)
        }
    }
}
