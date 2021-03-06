//
//  AlertController.swift
//  FireChat
//
//  Created by Petre Vane on 26/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit
import DeviceTypes

// adopted by ChannelsViewController
protocol AlertControllerDelegate: AnyObject {
    func didCreateNewChatRoom(_ channel: ChatRoom)
}

/// Presents two types of Alerts
///
/// - One type (Informing Alert) contains two labels and one button. It is used for
/// showing alert messages.
/// - The other type (Action Alert) contains one label, two text fields and two buttons. This alert is used only in ChannelsViewController, for getting user's input when creating a new channel / chat room.
class AlertController: UIViewController {

    weak var delegate: AlertControllerDelegate?
    let alertContainerView = AlertView()
    let titleLabel = FireLabel(textAlignment: .center, fontSize: 10)
    let bodyLabel = FireLabel(textAlignment: .center, fontSize: 5)
    let actionButton = FireButton(backgroundColor: .systemGreen, title: "Add chat room")
    let cancelButton = FireButton(backgroundColor: .systemRed, title: "Cancel")
    let titleTextField = FireTextField()
    let descriptionTextField = FireTextField()
    let padding: CGFloat = 30
    
    var alertTitle: String?
    var alertMessage: String?
    var buttonTitle: String?
    
    
    init(alertTitle: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = alertTitle
        self.alertMessage = message
        self.buttonTitle = buttonTitle
        presentInformingAlert()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        presentActionAlert()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.dismissKeyboardOnTap()
        titleTextField.delegate = self
        descriptionTextField.delegate = self
    }
    
    private func presentInformingAlert() {
        configureAlertContainer()
        configureTitleLabel()
        configureBodyLabel()
        configureActionButton()
    }
    
    private func presentActionAlert() {
        // container
        configureAlertContainer()
        
        // title label
        configureTitleLabel()
        titleLabel.text = "Add a new chat room"
        titleLabel.textColor = .systemOrange
        
        // text fields
        alertContainerView.addSubview(titleTextField)
        alertContainerView.addSubview(descriptionTextField)
        titleTextField.placeholder = "Chat room title"
        descriptionTextField.placeholder = "Chat room description"
        
        // stackView
        let stackView = configureStackView()
        alertContainerView.addSubview(stackView)
        stackView.addArrangedSubview(actionButton)
        stackView.addArrangedSubview(cancelButton)
        stackView.setCustomSpacing(15, after: actionButton)
        
        // button actions
        actionButton.addTarget(self, action: #selector(didPressActionButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didPressCancelButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            titleTextField.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor, constant: padding),
            titleTextField.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor, constant: -padding),
            titleTextField.heightAnchor.constraint(equalToConstant: 35),
            
            descriptionTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            descriptionTextField.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            descriptionTextField.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            descriptionTextField.heightAnchor.constraint(equalTo: titleTextField.heightAnchor),
            
            stackView.bottomAnchor.constraint(equalTo: alertContainerView.bottomAnchor, constant: -padding),
            stackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureAlertContainer() {
        view.addSubview(alertContainerView)
        let topPaddingConstraint: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? -90 : -45
        NSLayoutConstraint.activate([
            alertContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: topPaddingConstraint),
            alertContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertContainerView.heightAnchor.constraint(equalToConstant: 300),
            alertContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50)
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
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureBodyLabel() {
        view.addSubview(bodyLabel)
        bodyLabel.text = alertMessage ?? "Unable to complete request!"
        bodyLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        bodyLabel.numberOfLines = 4
        titleLabel.textColor = .secondaryLabel
        titleLabel.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            bodyLabel.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor, constant: padding),
            bodyLabel.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor, constant: -padding),
            bodyLabel.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func configureCancelButton() {
        view.addSubview(cancelButton)
        cancelButton.setTitle("Cancel", for: .normal)
    }
    
    private func configureActionButton() {
        view.addSubview(actionButton)
        actionButton.setTitle(buttonTitle ?? "Dismiss", for: .normal)
        actionButton.backgroundColor = .systemOrange
        actionButton.addTarget(self, action: #selector(didPressCancelButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: alertContainerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureStackView() -> UIStackView {
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }

    @objc private func didPressCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didPressActionButton() {
        createNewChatRoom()
    }
    
    @objc private func didPressReturnButton() {
        view.endEditing(true)
    }
    
    private func createNewChatRoom() {
        guard let title = titleTextField.text else { return }
        guard let description = descriptionTextField.text else { return }
        
        if title.isEmpty || description.isEmpty {
            self.presentAlert(withTitle: "Missing values", message: "You need to provide both a Title and a short Description of your chat room!", buttonTitle: "Ok")
            return
        }
        let chatRoom = ChatRoom(title: title, description: description)
        delegate?.didCreateNewChatRoom(chatRoom)
        dismiss(animated: true, completion: nil)
    }
}

extension AlertController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didPressReturnButton()
        return true
    }
}

