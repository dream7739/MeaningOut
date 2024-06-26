//
//  ShopNotification.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/17/24.
//

import UIKit

struct ShopNotification {
    static let delete = Notification.Name("SearchDeleteNotification")
    static let like = Notification.Name("LikeClickNotification")
    static let network = Notification.Name("NetworkRetryNotification")
}

struct ShopNotificationKey {
    static let indexPath = "indexPath"
}
