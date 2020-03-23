//
//  PasswordResetViewController.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

protocol PasswordResetDelegate: AnyObject {
    func didPressPasswordResetButton()
}

class PasswordResetViewController: UIViewController {

    weak var delegate: PasswordResetDelegate?
    let label = FireLabel(textAlignment: .center, fontSize: 25)
    let emailTextField = FireTextField()
    let resetButton = FireButton(backgroundColor: .systemYellow, title: "Reset password now")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUIElements()
        view.dismissKeyboardOnTap()
    }
    
    private func configureUIElements() {
        let padding: CGFloat = 50
        //label
        label.text = "Reset your password here"
        label.backgroundColor = .systemBackground
        //textField
        emailTextField.placeholder = "Type in your email address"
        //button
        resetButton.addTarget(self, action: #selector(didPressResetButton), for: .touchUpInside)
        resetButton.setTitleColor(.systemBlue, for: .normal)
        let customViews = [label, emailTextField, resetButton]
        for customView in customViews {
            view.addSubview(customView)
            NSLayoutConstraint.activate([
            
                customView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                customView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
                customView.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            emailTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: padding),
            resetButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20)
        ])
    }
    
    @objc private func didPressResetButton() {
        delegate?.didPressPasswordResetButton()
    }
}

extension PasswordResetViewController {
    
    class func instantiate(delegate: PasswordResetDelegate) -> PasswordResetViewController {
        let viewController = PasswordResetViewController()
        viewController.delegate = delegate
        return viewController
    }
}
