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
}

class WelcomeVC: UIViewController {
    
    weak var delegate: WelcomeVCDelegate?
    let welcomeLabel = FireLabel(textAlignment: .center, fontSize: 30)
    let emailButton = FireButton(backgroundColor: .systemRed, title: "Log in with email")

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
        view.addSubview(emailButton)
        emailButton.addTarget(self, action: #selector(didPressEmailButton), for: .touchUpInside)
        let padding: CGFloat = 50
        
        NSLayoutConstraint.activate([
        
            emailButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            emailButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding / 2),
            emailButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding / 2),
            emailButton.heightAnchor.constraint(equalToConstant: padding)
        ])
    }
    
    @objc func didPressEmailButton() {
        delegate?.didPressEmailButton()
    }

}

extension WelcomeVC {
    
    class func instantiate(delegate: WelcomeVCDelegate) -> WelcomeVC {
        let viewController = WelcomeVC()
        viewController.delegate = delegate
        return viewController
    }
}
