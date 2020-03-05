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
    
    func presentWelcomeVC() {
        guard let viewController = router.navigationController.viewControllers.first as? WelcomeVC else { return }
        viewController.delegate = self
    }
    
    func presentLoginVC() {
        let loginVC = LoginVC.instantiate(delegate: self)
        router.present(loginVC, animated: true)
    }
    
    func presentSignUPVC() {
        let signUpVC = SignUpVC.instantiate(delegate: self)
        router.present(signUpVC, animated: true)
    }
    
    func presentPasswordResetVC() {
        let passwordResetVC = PasswordResetVC.instantiate(delegate: self)
        router.present(passwordResetVC, animated: true)
    }
    
}

extension AuthenticationCoordinator: WelcomeVCDelegate {
    func didPressGoogleButton() {
        print("Google button pressed")
    }
    
    func didPressNewAccountButton() {
        print("New account button pressed")
        presentSignUPVC()
    }
    
    func didPressEmailButton() {
        presentLoginVC()
    }
}

extension AuthenticationCoordinator: LoginVCDelegate {
    func didPressForgotPasswordButton() {
        print("LoginVC pressed fogot password button")
        presentPasswordResetVC()
    }
}

extension AuthenticationCoordinator: SignUPDelegate {
    
}

extension AuthenticationCoordinator: PasswordResetDelegate {
    
    func didPressPasswordResetButton() {
        print("Reset passwd button pressed")
        router.navigationController.popToRootViewController(animated: true)
    }

}
