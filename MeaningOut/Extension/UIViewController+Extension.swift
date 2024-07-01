//
//  UIViewController+Extension.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/13/24.
//

import UIKit
import Toast

extension UIViewController {
    func configureView(){
        view.backgroundColor = .white
    }
    
    func configureNav(_ viewType: ViewType){
        navigationItem.title = viewType.navigationTitle
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: Design.FontType.gmarketMedium!
        ]
        
        let backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )
        
        backBarButtonItem.tintColor = .black
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func configureRootView(_ viewController: UIViewController){
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = viewController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func showAlert(_ title: String?, _ message: String?, 
                   _ completion: @escaping (UIAlertAction) -> ()){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default, handler: completion)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func showToast(_ text: String){
        var toastStyle = ToastStyle()
        toastStyle.cornerRadius = 20
        toastStyle.horizontalPadding = 15
        toastStyle.backgroundColor = Design.ColorType.primary
        
        view.makeToast(
            text,
            duration: 1.0,
            point: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 1.4),
            title: nil,
            image: nil,
            style: toastStyle,
            completion: nil
        )
        
    }
    
}

extension UIViewController {
    enum ViewType {
        case onboard
        case nickname
        case profile
        case search
        case result
        case detail
        case setting
        case editNickname
        case editProfile

        var navigationTitle: String {
            switch self {
            case .nickname, .profile:
                return "PROFILE SETTING"
            case .search:
                return "\(UserManager.nickname)`s MEANING OUT"
            case .onboard, .result, .detail:
                return ""
            case .setting:
                return "SETTING"
            case .editNickname, .editProfile:
                return "EDIT PROFILE"
            }
        }
        
    }
}

