//
//  CoreAppCoordinator.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit


class MainAppCoordinator: NSObject, Coordinator {

    var router: Router = NavigationRouter(navigationController: UINavigationController())
    weak var parentCoordinator: ApplicationCoordinator?
    
    init(coordinator: ApplicationCoordinator) {
        self.parentCoordinator = coordinator
    }
    
    func start() { }
 
    func removeCoordinator(_ coordinator: Coordinator) {
        parentCoordinator?.removeCoordinator(self)
    }
    
    func instantiateTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [startChannelViewController(), startProfileViewController()]
        return tabBar
    }
    
    func startChannelViewController() -> UINavigationController {
        let channelsVC = ChannelsViewController.instantiate(delegate: self)
        channelsVC.tabBarItem = UITabBarItem(title: "ChatRooms", image: Images.tabBarMessage.withRenderingMode(.alwaysOriginal), tag: 0)
        router.navigationController.setViewControllers([channelsVC], animated: false)
        return router.navigationController
    }
    
    private func startProfileViewController() -> UINavigationController {
        let profileVC = ProfileViewController.instantiate(delegate: self)
        profileVC.tabBarItem = UITabBarItem(title: "Your account", image: Images.tabBarFemale.withRenderingMode(.alwaysOriginal), tag: 1)
        return UINavigationController(rootViewController: profileVC)
    }
    
    private func startChatViewController(forChatRoom chatRoom: ChatRoom) {
        let chatViewController = ChatViewController.instantiate(delegate: self)
        chatViewController.chatRoom = chatRoom
         #if targetEnvironment(macCatalyst)
            router.present(chatViewController, animated: false)
        #else
            router.present(chatViewController, animated: true)
        #endif
    }
}


extension MainAppCoordinator: ChannelsVCDelegate {
    func didPressChatRoom(_ chatRoom: ChatRoom) {
        startChatViewController(forChatRoom: chatRoom)
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
