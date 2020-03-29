//
//  AlertController.swift
//  FireChat
//
//  Created by Petre Vane on 26/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

class AlertController: UIViewController {

    let alertContainerView = AlertView()
    let titleLabel = FireLabel(textAlignment: .center, fontSize: 10)
    let bodyLabel = FireLabel(textAlignment: .center, fontSize: 5)
    let actionButton = FireButton(backgroundColor: .systemRed, title: "Ok, let's move on")
    let padding: CGFloat = 20
    
    var alertTitle: String?
    var alertMessage: String?
    var buttonTitle: String?
    
    init(alertTitle: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = alertTitle
        self.alertMessage = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureAlertContainer()
        configureTitleLabel()
        configureBodyLabel()
        configureActionButton()
    }
    
    private func configureAlertContainer() {
        view.addSubview(alertContainerView)
        
        NSLayoutConstraint.activate([
            alertContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertContainerView.heightAnchor.constraint(equalToConstant: 200),
            alertContainerView.widthAnchor.constraint(equalToConstant: 320)
        ])
    }
    
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something went horribly wrong"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
        
            titleLabel.topAnchor.constraint(equalTo: alertContainerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
        
    }
    
    private func configureBodyLabel() {
        view.addSubview(bodyLabel)
        bodyLabel.text = alertMessage ?? "Unable to complete request!"
        bodyLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        bodyLabel.numberOfLines = 2
        
        titleLabel.textColor = .secondaryLabel
        titleLabel.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
        
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            bodyLabel.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor, constant: padding),
            bodyLabel.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor, constant: -padding),
            bodyLabel.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func configureActionButton() {
        view.addSubview(actionButton)
        actionButton.setTitle(buttonTitle ?? "Dismiss", for: .normal)
        actionButton.addTarget(self, action: #selector(didPressActionButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
        
            actionButton.bottomAnchor.constraint(equalTo: alertContainerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc private func didPressActionButton() {
        dismiss(animated: true, completion: nil)
    }
}
