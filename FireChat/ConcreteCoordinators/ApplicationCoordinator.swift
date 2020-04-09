//
//  ApplicationCoordinator.swift
//  FireChat
//
//  Created by Petre Vane on 10/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

class ApplicationCoordinator {
    
    var window: UIWindow?
    var childCoordinators: [Coordinator] = []
    let firebase = FirebaseAuth.shared
    var isUserAuthorized = false { didSet { decideAppFlow() } }
    
    init(window: UIWindow) {
        self.window = window
        start()
        configureAppearance()
    }
    
    func start() {
        isUserLoggedIn()
        decideAppFlow()
     }
    
    private func decideAppFlow() {
        switch isUserAuthorized {
            case true: startMainFlow()
            case false: startAuthenticationFlow()
        }
    }
    
    private func isUserLoggedIn() {
        firebase.checkIfSignedIn { [weak self ](signedIn) in
            guard let self = self else { return }
            if signedIn { self.isUserAuthorized = true }
        }
    }
    
    func startAuthenticationFlow() {
        let authenticationCoordinator = AuthenticationCoordinator(coordinator: self)
        addCoordinator(authenticationCoordinator)
        window?.rootViewController = authenticationCoordinator.router.navigationController
    }
    
    func startMainFlow() {
        let mainAppCoordinator = MainAppCoordinator(coordinator: self)
        childCoordinators.append(mainAppCoordinator)
        window?.rootViewController = mainAppCoordinator.instantiateTabBar()
    }
    
    func addCoordinator(_ coordinator: Coordinator) {
        for element in childCoordinators { if element === coordinator { return } }
        childCoordinators.append(coordinator)
    }
    
    func removeCoordinator(_ coordinator: Coordinator) {
        guard childCoordinators.isEmpty == false else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if coordinator === element {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    // Configures NavigationBar Appearance
    func configureAppearance() {
        // changes general appearance
        UINavigationBar.appearance().tintColor = .systemOrange
        UITabBar.appearance().tintColor = .systemOrange
    }
}
