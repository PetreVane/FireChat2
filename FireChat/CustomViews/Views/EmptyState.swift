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
    private let mainLabel = FireLabel(textAlignment: .center, fontSize: 20)
    private let secondaryLabel = FireLabel(textAlignment: .center, fontSize: 18)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
        configureLabel()
        configureSecondaryLabel()
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
    
    private func configureLabel() {
        addSubview(mainLabel)
        mainLabel.textColor = .systemBlue
        mainLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        mainLabel.text = "No Messages!"
        
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            mainLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            mainLabel.widthAnchor.constraint(equalToConstant: 150),
            mainLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func configureSecondaryLabel() {
        addSubview(secondaryLabel)
        let padding: CGFloat = 20
        secondaryLabel.textColor = .secondaryLabel
        secondaryLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        secondaryLabel.text = "Start typing a message"

        
        NSLayoutConstraint.activate([
        
            secondaryLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: padding / 2),
            secondaryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            secondaryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            secondaryLabel.heightAnchor.constraint(equalToConstant: 30)
            
        ])
    }
    
}
