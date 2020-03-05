//
//  SignUpVC.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

protocol SignUPDelegate: AnyObject {
    func signUpButtonPressed()
}

class SignUpVC: UIViewController {
    
    weak var delegate: SignUPDelegate?
    let nameTextField = FireTextField()
    let emailTextField = FireTextField()
    let passwordTextField = FireTextField()
    let signUpButton = FireButton(backgroundColor: .systemYellow, title: "Sign me up for a new account")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUIElements()
        view.dismissKeyboardOnTap()
    }
    
    private func configureUIElements() {
        let padding: CGFloat = 50
        nameTextField.placeholder = "Type in your name"
        emailTextField.placeholder = "Type in your email address"
        passwordTextField.placeholder = "Type in a new password"
        passwordTextField.isSecureTextEntry = true
        signUpButton.setTitleColor(.systemBlue, for: .normal)
        signUpButton.addTarget(self, action: #selector(didPressSignUPButton), for: .touchUpInside)
        let customViews = [nameTextField, emailTextField, passwordTextField, signUpButton]
        for customView in customViews {
            view.addSubview(customView)
            NSLayoutConstraint.activate([
                customView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                customView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
                customView.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
        
        NSLayoutConstraint.activate([
        
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            
        ])
    }
    
    @objc private func didPressSignUPButton() {
        delegate?.signUpButtonPressed()
    }
    
    
}

extension SignUpVC {
    
    class func instantiate(delegate: SignUPDelegate) -> SignUpVC {
        let viewController = SignUpVC()
        viewController.delegate = delegate
        return viewController
    }
}


