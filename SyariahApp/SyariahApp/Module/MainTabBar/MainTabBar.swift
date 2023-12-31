//
//  MainTabBar.swift
//  SyariahApp
//
//  Created by Phincon on 30/10/23.
//

import Foundation
import UIKit

class MainTabBarViewController: UITabBarController {
    
    let homeVC = UINavigationController(rootViewController: HomeViewController())
    let transactionVC = UINavigationController(rootViewController: TransactionViewController())
    let notificationVC = UINavigationController(rootViewController: NotificationViewController())
    let profileVC = UINavigationController(rootViewController: ProfileViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUITabBarItems()
        setViewControllers()
        tabBar.backgroundColor = UIColor.white
    }
    
    func configureUITabBarItems(){
        homeVC.tabBarItem = UITabBarItem(title: "home", image: tabBarIcon.homeIcon, tag: 0)
        transactionVC.tabBarItem = UITabBarItem(title: "notification", image: tabBarIcon.historyIcon, tag: 1)
        notificationVC.tabBarItem = UITabBarItem(title: "transaction", image: tabBarIcon.inboxIcon, tag: 2)
        profileVC.tabBarItem = UITabBarItem(title: "profile", image: tabBarIcon.profileIcon, tag: 3)
    }
    
     func setViewControllers() {
        setViewControllers([homeVC,transactionVC,notificationVC,profileVC], animated: true)
    }
    
}

