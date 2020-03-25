//
//  CoreAppCoordinator.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit


class MainAppCoordinator: Coordinator {

    var router: Router
    weak var parentCoordinator: ApplicationCoordinator?
    init(router: NavigationRouter) {
        self.router = router
    }
    
    func start() {
        // starts this coordinator
//        _ = TabBar()
        let tabBar = UITabBarController()
        tabBar.viewControllers = [startChannelViewController(), startProfileViewController()]
    }
 
    func removeCoordinator(_ coordinator: Coordinator) {
        parentCoordinator?.removeCoordinator(self)
    }
    
    private func startChannelViewController() -> UINavigationController {
        let channelsVC = ChannelsViewController.instantiate(delegate: self)
        channelsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        
        return UINavigationController(rootViewController: channelsVC)
    }
    
    private func startProfileViewController() -> UINavigationController {
        let profileVC = ProfileViewController.instantiate(delegate: self)
        profileVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        return UINavigationController(rootViewController: profileVC)
    }
}

extension MainAppCoordinator: ChannelsVCDelegate {
    
}

extension MainAppCoordinator: ProfileVCDelegate {
    
    
}
