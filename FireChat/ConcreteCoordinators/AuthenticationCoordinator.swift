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
        // does nothing; Authentication coordinator is own by AuthenticationRouter
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
        
    }
    
    func didPressNewAccountButton() {
        presentSignUPVC()
    }
    
    func didPressEmailButton() {
        presentLoginVC()
    }
}

extension AuthenticationCoordinator: LoginVCDelegate {
    func didPressLoginButton() {
        prepateTabBar()
    }
    
    func didPressForgotPasswordButton() {
        presentPasswordResetVC()
    }
}

extension AuthenticationCoordinator: SignUPDelegate {
    func signUpButtonPressed() {
        router.navigationController.popToRootViewController(animated: true)
    }
}

extension AuthenticationCoordinator: PasswordResetDelegate {
    
    func didPressPasswordResetButton() {
        router.navigationController.popToRootViewController(animated: true)
    }
}

extension AuthenticationCoordinator {
    
    func prepateTabBar() {
//        SceneDelegate.shared.presenter = 
    }
}
