//
//  UIViewController+Ext.swift
//  FireChat
//
//  Created by Petre Vane on 26/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit


extension UIViewController {
    
    // Shows an alert to the user
    /// - Parameters:
    ///   - title: represents the alert title
    ///   - message: message contained by the alert
    ///   - buttonTitle: text contained by the button
    func presentAlert(withTitle title: String, message: String, buttonTitle: String) {
        
        DispatchQueue.main.async {
            let alert = AlertController(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showEmptyState(withTitle title: String, message: String) {
        let emptyState = EmptyState(frame: .zero, title: title, message: message)
        emptyState.frame = view.bounds
        view.addSubview(emptyState)
    }
}
