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
        configureTabBarController()
        setUpTabBarAppearence()
   }
    
    func configureTabBarController(){
        
        let searchVC = SearchViewController()
        let searchNav = UINavigationController(rootViewController: searchVC)

        let likeVC = LikeViewController()
        let likeNav = UINavigationController(rootViewController: likeVC)
        
        let settingVC = SettingViewController()
        let settingNav = UINavigationController(rootViewController: settingVC)
        
        searchVC.tabBarItem = UITabBarItem(
            title: "검색",
            image: ImageType.search,
            tag: 0
        )
        likeVC.tabBarItem = UITabBarItem(
            title: "좋아요",
            image: ImageType.like_unselected,
            tag: 1
        )
        settingNav.tabBarItem = UITabBarItem(
            title: "설정",
            image: ImageType.profile,
            tag: 2
        )
        
        setViewControllers([searchNav, likeNav, settingNav], animated: true)
    }
    
    
    func setUpTabBarAppearence(){
        let apperance = UITabBarAppearance()
        apperance.configureWithTransparentBackground()
        tabBar.standardAppearance = apperance
        tabBar.scrollEdgeAppearance = apperance
        tabBar.tintColor = ColorType.theme
    }
}
