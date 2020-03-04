//
//  WelcomeVC.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
    let welcomeLabel = FireLabel(textAlignment: .center, fontSize: 30)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureWelcomeLabel()
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

}
