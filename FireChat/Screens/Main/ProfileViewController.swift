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
    private let label = FireLabel(textAlignment: .center, fontSize: 15)
    private let logoutButton = FireButton(backgroundColor: .systemRed, title: "Log out")
    private let profileImageView = UIImageView()
    private let padding: CGFloat = 50
    private let firebase = FirebaseAuth.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureProfileImageView()
        configureLabel()
        configureLogOutButton()
        title = "Your account"
    }
    
    private func configureProfileImageView() {
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 30
        profileImageView.image = Images.defaultProfileImage
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.backgroundColor = .secondarySystemBackground
        
        
        let topAnchor = profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding)
        let leadingAnchor = profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let widthAnchor = profileImageView.widthAnchor.constraint(equalToConstant: padding * 3)
        let heightAnchor = profileImageView.heightAnchor.constraint(equalToConstant: padding * 3)
        NSLayoutConstraint.activate([topAnchor, leadingAnchor, widthAnchor, heightAnchor])
    }
    
    private func configureLabel() {
        view.addSubview(label)
        let firebaseUser = firebase.loggedInUser.first ?? User(name: "Stranger", email: "hidden email address", photoURL: nil, provider: nil)
        label.text = "Your user name is \(firebaseUser.displayName)"
        label.backgroundColor = .tertiarySystemBackground
        
        NSLayoutConstraint.activate([
        
            label.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: padding / 2),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
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
