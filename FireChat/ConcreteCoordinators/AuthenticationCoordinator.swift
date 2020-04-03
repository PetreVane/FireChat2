//
//  AuthenticationCoordinator.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit


class AuthenticationCoordinator: Coordinator {

    var router: Router = NavigationRouter(navigationController: UINavigationController())
    var childControllers: [UIViewController] = []
    weak var parentCoordinator: ApplicationCoordinator?

    init(coordinator: ApplicationCoordinator) {
        self.parentCoordinator = coordinator
        start()
    }
    
    func start() {
        presentWelcomeVC()
    }
    
    func removeCoordinator(_ coordinator: Coordinator) {
        parentCoordinator?.removeCoordinator(self)
    }
    
    func presentWelcomeVC() {
        let welcomeScreen = WelcomeViewController.instantiate(delegate: self)
        router.present(welcomeScreen, animated: true)
        childControllers.append(welcomeScreen)
    }
    
    func presentLoginVC() {
        let loginVC = LoginViewController.instantiate(delegate: self)
        router.present(loginVC, animated: true)
    }
    
    func presentSignUPVC() {
        let signUpVC = SignUpViewController.instantiate(delegate: self)
        router.present(signUpVC, animated: true)
    }
    
    func presentPasswordResetVC() {
        let passwordResetVC = PasswordResetViewController.instantiate(delegate: self)
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
    func userHasLoggedIn() {
        parentCoordinator?.isUserAuthorized = true
        parentCoordinator?.removeCoordinator(self)
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
    
}
