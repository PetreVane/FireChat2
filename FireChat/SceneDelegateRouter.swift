//
//  SceneDelegateRouter.swift
//  FireChat
//
//  Created by Petre Vane on 05/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

class SceneDelegateRouter: UIViewController {
    
    var authenticationCoordinator: AuthenticationCoordinator?
    var coreAppCoordinator: CoreAppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    /// Starts authentication flow
    func startViewController() {
        let welcomeVC = WelcomeVC()
        let navigationController = UINavigationController.init(rootViewController: welcomeVC)
        let router = NavigationRouter(navigationController: navigationController)
        authenticationCoordinator = AuthenticationCoordinator(navigationRouter: router)
        authenticationCoordinator?.presentWelcomeVC()
    }
    
    /// Instantiates a TabBar controller & sets a general color
       func tabBarController() {
        _ = TabBar()
           UITabBar.appearance().tintColor = .systemRed
       }
    
    /// Configures NavigationBar Appearance
    func configureNavigationBar() {
        // changes general appearance
        UINavigationBar.appearance().tintColor = .systemOrange
    }
    
}
