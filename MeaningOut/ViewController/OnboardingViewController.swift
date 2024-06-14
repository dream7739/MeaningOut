//
//  OnboardingViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/13/24.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController {

    let titleLabel = UILabel()
    let launchImage = UIImageView()
    let startButton = RoundButton(buttonType: .onboard)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureHierarchy()
        configureLayout()
        configureUI()
        
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }
    
    @objc func startButtonClicked(){
        let vc = NicknameViewController()
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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        launchImage.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(76)
            make.height.equalTo(launchImage.snp.width).multipliedBy(1.3)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        
    }
    
    func configureUI() {
        titleLabel.text = "MeaningOut"
        titleLabel.font = .systemFont(ofSize: 40, weight: .heavy)
        titleLabel.textColor = Constant.ColorType.theme
        
        launchImage.contentMode = .scaleAspectFill
        launchImage.image = Constant.ImageType.start
        
    }
}
