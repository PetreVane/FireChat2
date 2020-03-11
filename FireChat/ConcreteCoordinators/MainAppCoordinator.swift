//
//  CoreAppCoordinator.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit


class MainAppCoordinator: Coordinator {

    var router: Router
    weak var parentCoordinator: BaseCoordinator?
    init(router: NavigationRouter) {
        self.router = router
    }
    
    func start() {
        // starts this coordinator
    }
 
    func removeCoordinator(_ coordinator: Coordinator) {
        parentCoordinator?.removeCoordinator(self)
    }
}
