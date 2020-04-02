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
    var tabBar: UITabBarController?
    weak var parentCoordinator: ApplicationCoordinator?
    
    init(router: NavigationRouter) {
        self.router = router
    }
    
    func start() {
        tabBar = instantiateTabBar()
    }
 
    func removeCoordinator(_ coordinator: Coordinator) {
        parentCoordinator?.removeCoordinator(self)
    }
    
    func instantiateTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [startChannelViewController(), startProfileViewController()]
        return tabBar
    }
    
    private func startChannelViewController() -> UINavigationController {
        let channelsVC = ChannelsViewController.instantiate(delegate: self)
        channelsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
       
        return  UINavigationController(rootViewController: channelsVC)
    }
    
    private func startProfileViewController() -> UINavigationController {
        let profileVC = ProfileViewController.instantiate(delegate: self)
        profileVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        return UINavigationController(rootViewController: profileVC)
    }
    
    private func startChatViewController() {
        // should accept a chatRoom
        let chatVC = ChatViewController.instantiate(delegate: self)
        KeyWindow.rootViewController?.present(chatVC, animated: true)
//        let vc = router.navigationController.topViewController
//        vc?.showDetailViewController(chatVC, sender: nil)
//        print("RootNav controller: \(vc.debugDescription)")
//         router.navigationController.setViewControllers([channelsVC], animated: true)
    }
}

extension MainAppCoordinator: ChannelsVCDelegate {
    func didPressChatRoom(_ chatRoom: ChatRoom) {
        startChatViewController()
    }
}

extension MainAppCoordinator: ChatVCDelegate {
    
}

extension MainAppCoordinator: ProfileVCDelegate {
    func didPressLogout() {
        parentCoordinator?.isUserAuthorized = false
        parentCoordinator?.removeCoordinator(self)
    }
}
