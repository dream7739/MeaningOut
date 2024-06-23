//
//  TabBarController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit

class ShopTabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.unselectedItemTintColor = Constant.ColorType.secondary
        tabBar.tintColor = Constant.ColorType.theme
        
        let searchVC = SearchViewController()
        let nav1 = UINavigationController(rootViewController: searchVC)

        let settingVC = SettingViewController()
        let nav2 = UINavigationController(rootViewController: settingVC)
        
        nav1.tabBarItem = UITabBarItem(title: "검색", image: Constant.ImageType.search, tag: 0)
        nav2.tabBarItem = UITabBarItem(title: "설정", image: Constant.ImageType.profile, tag: 1)
        
        setViewControllers([nav1, nav2], animated: true)
   }
}
