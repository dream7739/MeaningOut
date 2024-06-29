//
//  CustomCollectionView.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/29/24.
//

import UIKit

enum CustomLayout {
    static func tagCollection() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let horizontalInset: CGFloat = 20
        let verticalInset: CGFloat = 5
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        return layout
    }
    
    static func resultCollection() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 20
        let horizontalInset: CGFloat = 20
        let verticalInset: CGFloat = 20
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        
        return layout
    }
    
}
