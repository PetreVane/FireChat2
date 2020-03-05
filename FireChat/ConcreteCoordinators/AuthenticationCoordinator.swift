//
//  AuthenticationCoordinator.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit


class AuthenticationCoordinator: Coordinator {
    
    var router: Router
    var childControllers: [UIViewController] = [] // not sure if this is usefull in this case
    
    init(navigationRouter: Router) {
        self.router = navigationRouter
    }
    
  
    
    
    func onDismissAction() {
        // does nothing; Authentication coordinator is own by AppDelegateRouter
    }
    
    func removeChild(_ viewController: UIViewController) {
        for (index, child) in childControllers.enumerated() {
            if child === viewController {
                childControllers.remove(at: index)
            }
        }
    }
    
    
    func startWelcomeVC() {
        guard let viewController = router.navigationController.viewControllers.first as? WelcomeVC else { return }
        viewController.delegate = self
    }
    
    func presentLoginVC() {
        let loginVC = LoginVC.instantiate(delegate: self)
        router.present(loginVC, animated: true)
    }
}

extension AuthenticationCoordinator: WelcomeVCDelegate {
    
    func didPressEmailButton() {
        presentLoginVC()
    }
}

extension AuthenticationCoordinator: LoginVCDelegate {
    func remove(_ viewController: LoginVC) {
        removeChild(viewController)
    }
    
    
}
