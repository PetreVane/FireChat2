//
//  AuthenticationRouter.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

class AuthenticationRouter: Presenter {
    
    var window: UIWindow
    var authenticationCoordinator: AuthenticationCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        setRootWindowTo(startViewController())
    }
    
    
    func setRootWindowTo(_ viewController: UIViewController) {
        //init authCoordinator
        window.rootViewController = viewController
        // shows start ViewController
        window.makeKeyAndVisible()
    }
    
    /// Starts authentication flow
    func startViewController() -> UIViewController {
        let welcomeVC = WelcomeVC()
        let navigationController = UINavigationController.init(rootViewController: welcomeVC)
        let router = NavigationRouter(navigationController: navigationController)
        authenticationCoordinator = AuthenticationCoordinator(navigationRouter: router)
        authenticationCoordinator?.presentWelcomeVC()
        return navigationController
    }
    

}

