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
    var childControllers: [UIViewController] = []
    init(router: Router) {
        self.router = router
    }
    
    
    func onDismissAction() {
        // does nothing; Authentication coordinator is own by AppDelegateRouter
    }
    
    
    func startWelcomeVC() -> UIViewController {
        let welcomeVC = WelcomeVC.instantiate(parentCoordinator: self)
        childControllers.append(welcomeVC)
        return welcomeVC
    }
    
}
