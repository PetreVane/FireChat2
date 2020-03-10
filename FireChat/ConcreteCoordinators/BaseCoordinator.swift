//
//  BaseCoordinator.swift
//  FireChat
//
//  Created by Petre Vane on 10/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

class BaseCoordinator: Coordinator {
    
    var router: Router
    var childCoordinators: [Coordinator] = []
    func onDismissAction() {
        //does somethind
    }
    
    init(router: Router) {
        self.router = router
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
