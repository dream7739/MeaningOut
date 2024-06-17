//
//  UIViewController+Extension.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/13/24.
//x

import UIKit

extension UIViewController {
    func configureView(){
        view.backgroundColor = .white
    }
    
    func configureNav(_ viewType: Constant.ViewType){
        guard let nav = navigationController else { return }
        navigationItem.title = viewType.navigationTitle
        nav.navigationBar.tintColor = .black

        let viewControllers = nav.viewControllers
        print(viewControllers)
    
       
        
        if viewType != .search && viewType != .setting {
            let backButton = UIBarButtonItem(image: Constant.ImageType.back, style: .plain, target: self, action: #selector(backButtonClicked))
            navigationItem.leftBarButtonItem = backButton
        }
        
    }
    
    @objc func backButtonClicked(){
        navigationController?.popViewController(animated: true)
    }
}
