//
//  CustomCollectionView.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/29/24.
//

import UIKit

enum CustomLayout {
    case sort(_ view: UIView)
    case profile(_ view: UIView)
    
    var spacing: CGFloat {
        switch self {
        case .sort:
            return 10
        case .profile:
            return 10
        }
    }
        
    var inset: (vertical: CGFloat, horizontal: CGFloat) {
        switch self {
        case .sort:
            return (5, 20)
        case .profile:
            return (20, 30)
        }
    }
    
    var itemSize: CGSize {
        switch self {
        case .sort:
            return .zero
        case .profile(let view):
            let width = (view.bounds.width - (spacing * 2) - (inset.horizontal * 2)) / 3
            return CGSize(width: width, height: width)
        }
    }
    
    var scrollDirection: UICollectionView.ScrollDirection {
        switch self {
        case .sort:
            return .horizontal
        case .profile:
            return .vertical
        }
    }
    
    func get() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = spacing
        let verticalInset: CGFloat = inset.vertical
        let horizontalInset: CGFloat = inset.horizontal
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = scrollDirection
        layout.sectionInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
        layout.itemSize = itemSize
        
        return layout
    }
   
    
}
