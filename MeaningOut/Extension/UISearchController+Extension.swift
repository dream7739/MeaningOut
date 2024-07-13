//
//  UISearchController+Extension.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/12/24.
//

import UIKit

extension UISearchController {
    func configureDesign(){
        searchBar.setValue("취소", forKey: "cancelButtonText")
        searchBar.tintColor = ColorType.black
        searchBar.searchTextField.placeholder = "브랜드, 상품 등을 입력하세요"
    }
}
