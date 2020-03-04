//
//  WelcomeVC.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
    let welcomeLabel = FireLabel(textAlignment: .right, fontSize: 30)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureWelcomeLabel()
    }
    

    private func configureWelcomeLabel() {
        view.addSubview(welcomeLabel)
        welcomeLabel.text = "Welcome to FireChat"
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
        
            welcomeLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: padding),
            welcomeLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: padding),
            welcomeLabel.trailingAnchor.constraint(equalToSystemSpacingAfter: view.trailingAnchor, multiplier: -padding),
            welcomeLabel.heightAnchor.constraint(equalToConstant: padding * 5)
        ])
    }

}
