//
//  AlertView.swift
//  FireChat
//
//  Created by Petre Vane on 26/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

class AlertView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        // containerView attributes
        backgroundColor = .systemBackground
        layer.cornerRadius = 15
        layer.borderWidth = 2
        layer.borderColor = UIColor.tertiarySystemBackground.cgColor
        layer.backgroundColor = UIColor.systemBackground.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
