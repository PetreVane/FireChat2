//
//  TabBar.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

class TabBar: UITabBarController {
                
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [prepareChannelRouter(), prepareUserRouter()]
    }
    
    func prepareChannelRouter() -> UINavigationController {
         let channelVC = ChannelsViewController()
         channelVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
         return UINavigationController(rootViewController: channelVC)
     }
     
     func prepareUserRouter() -> UINavigationController {
        let userAccount = ProfileViewController()
        userAccount.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 1)
        return UINavigationController(rootViewController: userAccount)
     }
}
