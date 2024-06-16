//
//  CellProtocol.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/15/24.
//

import UIKit

protocol CellProtocol {
    func cellItemClicked(indexPath: IndexPath)
}

protocol LikeProtocol {
    func likeClicked(indexPath: IndexPath, isClicked: Bool)
}
