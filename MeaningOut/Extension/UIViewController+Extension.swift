//
//  UIViewController+Extension.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/13/24.
//x

import UIKit
import Toast

extension UIViewController {
    func configureView(){
        view.backgroundColor = .white
    }
    
    func configureNav(_ viewType: Constant.ViewType){
        navigationItem.title = viewType.navigationTitle
    }
    
    func showToast(_ text: String){
        var toastStyle = ToastStyle()
        toastStyle.cornerRadius = 20
        toastStyle.horizontalPadding = 15
        toastStyle.backgroundColor = Constant.ColorType.primary
        
        view.makeToast(text, duration: 1.0, point: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 1.4), title: nil, image: nil, style: toastStyle, completion: nil)
        
    }
    
}
