//
//  ReusableProtocol.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit

protocol ReusableProtocol: AnyObject {
    static var identifier: String { get }
}

extension ViewController: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
