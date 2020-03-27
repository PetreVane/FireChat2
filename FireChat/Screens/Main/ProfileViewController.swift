//
//  ProfileViewController.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

protocol ProfileVCDelegate: AnyObject {
    
}

class ProfileViewController: UIViewController {

    weak var delegate: ProfileVCDelegate?
    private let label = FireLabel(textAlignment: .center, fontSize: 25)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLabel()
    }
    

    private func configureLabel() {
        view.addSubview(label)
        label.text = "Welcome to Profile ViewController"
        let padding: CGFloat = 50
        label.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
        
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            label.heightAnchor.constraint(equalToConstant: padding)
        ])
    }

}

extension ProfileViewController {
    class func instantiate(delegate: ProfileVCDelegate) -> ProfileViewController {
        let viewController = ProfileViewController()
        viewController.delegate = delegate
        return viewController
    }
}
