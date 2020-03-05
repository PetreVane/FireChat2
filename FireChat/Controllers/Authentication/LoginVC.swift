//
//  LoginVC.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

protocol LoginVCDelegate: AnyObject {
    func didPressForgotPasswordButton()
}

class LoginVC: UIViewController {
    
    weak var delegate: LoginVCDelegate?
    let label = FireLabel(textAlignment: .center, fontSize: 25)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLabel()
    }
    
    
    private func configureLabel() {
        view.addSubview(label)
        label.text = "Sign in with Email"
        label.backgroundColor = .secondarySystemBackground
        let padding: CGFloat = 50
        
        NSLayoutConstraint.activate([
        
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: padding * 2),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            label.heightAnchor.constraint(equalToConstant: padding)
        ])
    }
    


}

extension LoginVC {
    
    class func instantiate(delegate: LoginVCDelegate) -> LoginVC {
        let viewController = LoginVC()
        viewController.delegate = delegate
        return viewController
    }
}
