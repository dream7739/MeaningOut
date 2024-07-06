//
//  TabBarController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit

final class ShopTabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.unselectedItemTintColor = Design.ColorType.secondary
        tabBar.tintColor = Design.ColorType.theme
        
        let searchVC = SearchViewController()
        let nav1 = UINavigationController(rootViewController: searchVC)

        let likeVC = LikeViewControlller()
        let nav2 = UINavigationController(rootViewController: likeVC)
        
        let settingVC = SettingViewController()
        let nav3 = UINavigationController(rootViewController: settingVC)
        
        nav1.tabBarItem = UITabBarItem(title: "검색", image: Design.ImageType.search, tag: 0)
        nav2.tabBarItem = UITabBarItem(title: "좋아요", image: Design.ImageType.like_unselected, tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "설정", image: Design.ImageType.profile, tag: 2)
        
        setViewControllers([nav1, nav2, nav3], animated: true)
   }
}
