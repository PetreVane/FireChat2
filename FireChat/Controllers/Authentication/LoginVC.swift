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
    func didPressLoginButton()
}

class LoginVC: UIViewController {
    
    weak var delegate: LoginVCDelegate?
    let label = FireLabel(textAlignment: .center, fontSize: 25)
    let userNameTextField = FireTextField()
    let passwordTextField = FireTextField()
    let loginButton = FireButton(backgroundColor: .systemYellow, title: "Login")
    let forgotPasswdButton = FireButton(backgroundColor: .systemOrange, title: "I forgot my password")
    private let padding: CGFloat = 50

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLabel()
        configureTextFields()
        configureButtons()
        view.dismissKeyboardOnTap()
    }
    
    private func configureLabel() {
        view.addSubview(label)
        label.text = "Sign in with Email"
        label.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
        
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            label.heightAnchor.constraint(equalToConstant: padding)
        ])
    }
    
    private func configureTextFields() {
        passwordTextField.placeholder = "Type in your password"
        passwordTextField.isSecureTextEntry = true
        let textFields = [userNameTextField, passwordTextField]
        
        for textField in textFields {
            view.addSubview(textField)
            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
                textField.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
        
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: padding),
            passwordTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 10)
        ])
    }
    
    private func configureButtons() {
        loginButton.setTitleColor(.systemBlue, for: .normal)
        forgotPasswdButton.setTitleColor(.label, for: .normal)
        loginButton.addTarget(self, action: #selector(didPressLoginButton), for: .touchUpInside)
        forgotPasswdButton.addTarget(self, action: #selector(didPressforgotPasswdButton), for: .touchUpInside)
        
        let buttons = [loginButton, forgotPasswdButton]
        for button in buttons {
            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
                button.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 25),
            forgotPasswdButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10)
        ])
    }
    
    @objc private func didPressforgotPasswdButton() {
        delegate?.didPressForgotPasswordButton()
    }
    
    @objc private func didPressLoginButton() {
        delegate?.didPressLoginButton()
    }
    
  
    
    

}

extension LoginVC {
    
    class func instantiate(delegate: LoginVCDelegate) -> LoginVC {
        let viewController = LoginVC()
        viewController.delegate = delegate
        return viewController
    }
}
