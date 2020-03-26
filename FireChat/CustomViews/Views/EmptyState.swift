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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Images.noMessages
        contentMode = .scaleAspectFit
        let padding: CGFloat = 425
        
        
        NSLayoutConstraint.activate([
            
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: padding),
            imageView.heightAnchor.constraint(equalToConstant: padding)
        ])
    }
    
}
