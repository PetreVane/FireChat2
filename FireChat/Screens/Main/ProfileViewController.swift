//
//  ProfileViewController.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

protocol ProfileVCDelegate: AnyObject {
    func didPressLogout()
}

class ProfileViewController: UIViewController {

    weak var delegate: ProfileVCDelegate?
    private let label = FireLabel(textAlignment: .center, fontSize: 25)
    private let logoutButton = FireButton(backgroundColor: .systemRed, title: "Log out")
    private let padding: CGFloat = 50
    private let firebase = FirebaseAuth.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLabel()
        configureLogOutButton()
        title = "Your account"
    }
    

    private func configureLabel() {
        view.addSubview(label)
        label.text = "Welcome to Profile ViewController"
        
        label.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
        
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            label.heightAnchor.constraint(equalToConstant: padding)
        ])
    }
    
    private func configureLogOutButton() {
        view.addSubview(logoutButton)
        logoutButton.addTarget(self, action: #selector(didPressLogout), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            logoutButton.heightAnchor.constraint(equalToConstant: padding)
        ])
    }
    
    @objc private func didPressLogout() {
        firebase.signOut()
        UserDefaults.standard.removeObject(forKey: "NotificationToken")
        delegate?.didPressLogout()
    }

}

extension ProfileViewController {
    class func instantiate(delegate: ProfileVCDelegate) -> ProfileViewController {
        let viewController = ProfileViewController()
        viewController.delegate = delegate
        return viewController
    }
}
