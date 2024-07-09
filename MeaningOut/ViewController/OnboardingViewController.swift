//
//  OnboardingViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/13/24.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {

    private let titleLabel = UILabel()
    private let launchImage = UIImageView()
    private let startButton = RoundButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(.onboard)
        configureHierarchy()
        configureLayout()
        configureUI()
        
        startButton.addTarget(
            self,
            action: #selector(startButtonClicked),
            for: .touchUpInside
        )
    }
}

extension OnboardingViewController {
    @objc 
    private func startButtonClicked(){
        let vc = NicknameViewController()
        vc.viewType = .nickname(.add)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension OnboardingViewController: BaseProtocol {
    func configureHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(launchImage)
        view.addSubview(startButton)
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(110)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        
        launchImage.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(60)
            make.height.equalTo(launchImage.snp.width).multipliedBy(1.2)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
    }
    
    func configureUI() {
        titleLabel.text = Design.serviceName
        titleLabel.font = Design.FontType.gmarketBold
        titleLabel.textColor = Design.ColorType.black
        
        launchImage.contentMode = .scaleAspectFill
        launchImage.layer.cornerRadius = 10
        launchImage.clipsToBounds = true
        
        startButton.setTitle("시작하기", for: .normal)
        
    }
}
