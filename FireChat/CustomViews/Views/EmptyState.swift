//
//  EmptyState.swift
//  FireChat
//
//  Created by Petre Vane on 26/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

class EmptyState: UIView {
    
    private let imageView = UIImageView()
    private let titleLabel = FireLabel(textAlignment: .center, fontSize: 20)
    private let messageLabel = FireLabel(textAlignment: .center, fontSize: 18)
    
    init(frame: CGRect, title: String, message: String) {
        super.init(frame: frame)
        configureImageView()
        configureTitleLabel(withTitle: title)
        configureMessageLabel(withMessage: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Images.noMessages
        contentMode = .center
        let padding: CGFloat = 125
        
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: padding)
        ])
    }
    
    private func configureTitleLabel(withTitle title: String) {
        addSubview(titleLabel)
        titleLabel.textColor = .systemOrange
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.text = title
        
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -50),
            titleLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 150),
            titleLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func configureMessageLabel(withMessage message: String) {
        addSubview(messageLabel)
        let padding: CGFloat = 20
        messageLabel.textColor = .secondaryLabel
        messageLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        messageLabel.text = message

        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding / 2),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            messageLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
}
