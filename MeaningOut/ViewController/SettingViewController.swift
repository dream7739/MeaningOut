//
//  SettingViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit

class SettingViewController: UIViewController {

    let headerView = UIView()
    
    let profileImage = RoundImageView(imageType: .highlight)
    
    let nicknameLabel = UILabel()
    
    let dateLabel = UILabel()
    
    let indicatorImage = UIImageView()
    
    let sepratorLabel = UILabel()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(.setting)
        configureHierarchy()
        configureLayout()
        configureUI()
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
            make.height.equalTo(1)
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
        
        sepratorLabel.backgroundColor = Constant.ColorType.secondary
        
        tableView.backgroundColor = .magenta
    }
    
    
}
