//
//  AppDelegateRouter.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

class AppDelegateRouter {
    
    let window: UIWindow
    var authenticationCoordinator: AuthenticationCoordinator? // keeps a reference to AuthCoordinator
    
    init(window: UIWindow) {
        self.window = window
        configureWindow()
    }
    
    /// Assigns tabBar to window
    func configureWindow() {
        
        //init tabbar
        window.rootViewController = startAuthentication() //initTabBar()
        // show the ViewController
        window.makeKeyAndVisible()
        // navBar
        configureNavigationBar()
    }
    
    /// Instantiates a TabBar controller & sets a general color
    func initTabBar() -> UITabBarController {
        
        let tabBar = TabBar()
        // change general appearance
        UITabBar.appearance().tintColor = .systemRed
        return tabBar
    }
    
    func startAuthentication() -> UIViewController {
        let welcomeVC = WelcomeVC()
        let navigationController = UINavigationController.init(rootViewController: welcomeVC)
        let router = NavigationRouter(navigationController: navigationController)
        authenticationCoordinator = AuthenticationCoordinator(navigationRouter: router)
        authenticationCoordinator?.startWelcomeVC()
        
        return navigationController
    }
    
    /// Configures NavigationBar Appearance
    func configureNavigationBar() {
        
        // change general appearance
        UINavigationBar.appearance().tintColor = .systemRed
    }
    
}
