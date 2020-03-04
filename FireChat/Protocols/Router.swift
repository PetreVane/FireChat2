//
//  Router.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit


/// Defines methods all concrete routers must implement
protocol Router: AnyObject {
    
    var navigationController: UINavigationController { get set }
    
    // Presents a viewController
    /// - Parameters:
    ///   - viewController: ViewController that should be presented
    ///   - animated: pass true to animate the transition
    func present(_ viewController: UIViewController, animated: Bool)
    
    /// Presents a viewController
    /// - Parameters:
    ///   - viewController: ViewController that should be presented
    ///   - animated: pass true to animate the transition
    ///   - onDismiss: closure to be executed when the viewController is dismissed
    func present(_ viewController: UIViewController, animated: Bool, onDismiss: (() -> Void)?)
    
    /// Dismisses a ViewController
       /// - Parameter animated: pass true to animate the transition
    func dismiss(animated: Bool)
}


extension Router {
    
    // Concrete implemetation of Present method
    func present(_ viewController: UIViewController, animated: Bool) {
        present(viewController, animated: animated, onDismiss: nil)
    }
}
