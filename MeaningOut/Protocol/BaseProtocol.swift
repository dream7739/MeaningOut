//
//  BaseProtocol.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/13/24.
//

import UIKit

@objc
protocol BaseProtocol: AnyObject {
    func configureHierarchy()
    func configureLayout()
    @objc optional func configureUI()
}

