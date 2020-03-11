//
//  Coordinator.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

///  Defines the methods and properties all concrete coordinators must implement
protocol Coordinator: AnyObject {
    func start()
    var router: Router { get set }
    func removeCoordinator(_ coordinator: Coordinator)
}
