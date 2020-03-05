//
//  NavigationRouter.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit



class NavigationRouter: NSObject {
    
    // base ViewController used by presetModally()
    unowned var baseViewController: UIViewController?
    var navigationController: UINavigationController
    private var onDismissForViewController: [UIViewController: (() -> Void)] = [:]
    
    init(navigationController: UINavigationController ) {
        self.navigationController = navigationController
        super.init()
        navigationController.delegate = self
    }
}


extension NavigationRouter: Router {

    func present(_ viewController: UIViewController, animated: Bool, onDismiss: (() -> Void)?) {

        onDismissForViewController[viewController] = onDismiss

        if baseViewController != nil {
            //calls presentModally, if there is a new instance of NavigationRouter, which has the 'baseViewController' set.
            print("Called NavigationRouter presentModally method for vc: \(viewController)")
            presentModally(viewController, animated: animated, onDismiss: onDismiss)
        } else {
           print("Called NavigationRouter present method for vc: \(viewController)")
           navigationController.pushViewController(viewController, animated: animated)
        }
    }

    func dismiss(animated: Bool) {
        guard let viewController = navigationController.viewControllers.first else { return }
        performOnDismissAction(for: viewController)
        baseViewController?.dismiss(animated: animated, completion: nil)
    }

     // MARK: - Private methods

    /// Presents a viewController modally
    /// - Parameters:
    ///   - viewController: ViewController to be presented
    ///   - animated: pass in true to animate the transition
    /// - adds a button (calls a method to add a button)
    /// - sets the viewController into navigationController's list of viewControllers
    /// - calls the present method of the parentVC and passes in the navigationController containg the ViewController
    private func presentModally(_ viewController: UIViewController, animated: Bool, onDismiss: (()-> Void)?) {
        navigationController.setViewControllers([viewController], animated: animated)
        addCancelButton(on: viewController)
        baseViewController?.present(navigationController, animated: animated, completion: nil)
    }

    /// Adds a navigation bar button item
    /// - Parameter viewController: viewController that contains the button
    private func addCancelButton(on viewController: UIViewController) {
        let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancelButtonPressed))
        viewController.navigationItem.rightBarButtonItem = cancelButton
    }

    @objc private func cancelButtonPressed() {
        guard let viewController = navigationController.viewControllers.first else { return }
        performOnDismissAction(for: viewController)
        baseViewController?.dismiss(animated: true, completion: nil)
    }

    /// Executes a closure when ViewController is dismissed
    /// - Parameter viewController: ViewController which is being dismissed
    /// - makes sure there is an associated closure for the passed in argument
    /// - executes the closure
    /// - removes the closure from dictionary and cancel the association between ViewController and closure
    private func performOnDismissAction(for viewController: UIViewController) {
        guard let onDismissAction = onDismissForViewController[viewController] else { return }
        onDismissAction()
        onDismissForViewController.removeValue(forKey: viewController)
    }

}

extension NavigationRouter: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let dismissedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        guard !navigationController.viewControllers.contains(dismissedViewController) else { return }
        performOnDismissAction(for: dismissedViewController)
    }
}
