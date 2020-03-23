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
    let router = NavigationRouter(navigationController: UINavigationController())
    var childCoordinators: [Coordinator] = []
        
    init(window: UIWindow) {
        self.window = window
        start()
    }
    
    func start() {
        // remember to include a Launch Instructor of some logic, to determine which flow to launch
//        startAuthenticationFlow()
        startMainFlow()
     }
    
    func startAuthenticationFlow() {
        let authenticationCoordinator = AuthenticationCoordinator(navigationRouter: router)
        authenticationCoordinator.start()
        addCoordinator(authenticationCoordinator)
        window?.rootViewController = authenticationCoordinator.router.navigationController
    }
    
    func startMainFlow() {
        let mainAppCoordinator = MainAppCoordinator(router: router)
        mainAppCoordinator.start()
        childCoordinators.append(mainAppCoordinator)
        window?.rootViewController = TabBar()
    }
    
    func addCoordinator(_ coordinator: Coordinator) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
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
}
