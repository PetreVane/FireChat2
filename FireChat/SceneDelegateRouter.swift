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
    var coreAppCoordinator: MainAppCoordinator?
    var isUserLogged = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        determineFLow()
        configureNavigationBar()
        
    }
    
    func determineFLow() {
        if isUserLogged {
            perform(#selector(startMainTab), with: nil, afterDelay: 0.01)
        } else {
            perform(#selector(startAuthFlow), with: nil, afterDelay: 0.01)
        }
    }
    
      
    /// Starts authentication flow
    @objc func startAuthFlow() {
        let welcomeVC = WelcomeVC()
        let navigationController = UINavigationController.init(rootViewController: welcomeVC)
        let router = NavigationRouter(navigationController: navigationController)
        authenticationCoordinator = AuthenticationCoordinator(navigationRouter: router)
        authenticationCoordinator?.presentWelcomeVC()
        navigationController.modalPresentationStyle = .overCurrentContext
        self.present(navigationController, animated: true, completion: nil)
    }
    
     /// Instantiates a TabBar controller & sets a general color
    @objc func startMainTab() {
        let tabBar = TabBar()
        tabBar.modalPresentationStyle = .overCurrentContext
        present(tabBar, animated: true, completion: nil)
        UITabBar.appearance().tintColor = .systemOrange
    }
    
    /// Configures NavigationBar Appearance
    func configureNavigationBar() {
        // changes general appearance
        UINavigationBar.appearance().tintColor = .systemOrange
    }
    
}
