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
        navigationItem.title = viewType.navigationTitle
    }
    
    @objc func backButtonClicked(){
        navigationController?.popViewController(animated: true)
    }
}
