//
//  WelcomeVC.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

// adopted by AuthenticationCoordinator
protocol WelcomeVCDelegate: AnyObject {
    func didPressEmailButton()
    func didPressGoogleButton()
    func didPressNewAccountButton()
}

class WelcomeVC: UIViewController {
    
    weak var delegate: WelcomeVCDelegate?
    let welcomeLabel = FireLabel(textAlignment: .center, fontSize: 30)
    let emailButton = FireButton(backgroundColor: .systemYellow, title: "Sign in with email account")
    let googleButton = FireButton(backgroundColor: .systemYellow, title: "Sign in with Google account")
    let newAccountButton = FireButton(backgroundColor: .systemYellow, title: "Create new account")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureWelcomeLabel()
        configureButtons()
    }
    

    private func configureWelcomeLabel() {
        view.addSubview(welcomeLabel)
        welcomeLabel.text = "Welcome to FireChat"
        welcomeLabel.backgroundColor = .systemBackground
        let padding: CGFloat = 50
        
        NSLayoutConstraint.activate([
        
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: padding * 2),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            welcomeLabel.heightAnchor.constraint(equalToConstant: padding * 2)
        ])
    }
    
    private func configureButtons() {
        let padding: CGFloat = 50
        let buttons = [newAccountButton, googleButton, emailButton]
        for button in buttons {
            view.addSubview(button)
            button.setTitleColor(.label, for: .normal)
            
            NSLayoutConstraint.activate([
            
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding / 2),
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding / 2),
                button.heightAnchor.constraint(equalToConstant: padding)
            ])
        }
        
        emailButton.addTarget(self, action: #selector(didPressEmailButton), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(didPressGoogleButton), for: .touchUpInside)
        newAccountButton.addTarget(self, action: #selector(didPressNewAccountButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
        
           newAccountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
           googleButton.bottomAnchor.constraint(equalTo: newAccountButton.topAnchor, constant: -15),
           emailButton.bottomAnchor.constraint(equalTo: googleButton.topAnchor, constant: -15)
        ])
    }
    
    @objc private func didPressEmailButton() {
        delegate?.didPressEmailButton()
    }
    
    @objc private func didPressGoogleButton() {
        delegate?.didPressGoogleButton()
    }
    
    @objc private func didPressNewAccountButton() {
        delegate?.didPressNewAccountButton()
    }

}

extension WelcomeVC {
    
    class func instantiate(delegate: WelcomeVCDelegate) -> WelcomeVC {
        let viewController = WelcomeVC()
        viewController.delegate = delegate
        return viewController
    }
}
