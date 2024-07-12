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
    
    func configureNav(_ navigation: ViewType){
        navigationItem.title = navigation.title
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: FontType.gmarketMedium!
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
}

extension UIViewController {
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
        toastStyle.backgroundColor = ColorType.primary
        
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
    enum Navigation {
        case push
        case pop
        case modal
        case modalFullscreen
        case dismiss
    }
    
    func transition<T: UIViewController>(_ viewController: T, _ style: Navigation){
        switch style {
        case .push:
            navigationController?.pushViewController(viewController, animated: true)
        case .pop:
            navigationController?.popViewController(animated: true)
        case .modal:
            present(viewController, animated: true)
        case .modalFullscreen:
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        case .dismiss:
            dismiss(animated: true)
        }
    }
    
    func transitionScene<T: UIViewController>(_ viewController: T){
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = viewController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}

extension UIViewController {
    func productLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 20
        let verticalInset: CGFloat = 20
        let horizontalInset: CGFloat = 20
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        
        layout.sectionInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
        
        let width: CGFloat = (view.bounds.width - spacing - horizontalInset * 2) / 2
        let height: CGFloat = (view.bounds.height - spacing - verticalInset * 2) / 2.9
        layout.itemSize = CGSize(width: width, height: height)
        
        return layout
    }
}
