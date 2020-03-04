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
    
    init(window: UIWindow) {
        self.window = window
        configureWindow()
    }
    
    /// Assigns tabBar to window
    func configureWindow() {
        
        //init tabbar
        window.rootViewController = initTabBar()
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
    
    /// Configures NavigationBar Appearance
    func configureNavigationBar() {
        
        // change general appearance
        UINavigationBar.appearance().tintColor = .systemRed
    }
    
}
