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
    
    init(router: NavigationRouter) {
        self.router = router
    }
    
    func onDismissAction() {
        print("CoreAppCoordinator dismissed")
    }
    
    
}
