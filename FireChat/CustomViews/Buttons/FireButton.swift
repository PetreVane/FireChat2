//
//  FireButton.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

class FireButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   convenience init(color: UIColor, title: String) {
        self.init(frame: .zero)
        self.backgroundColor = color
        self.setTitle(title, for: .normal)
    }
    
    private func configureButton() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 15
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    }
    
    func setButtonWith(color: UIColor, andTitle title: String) {
        backgroundColor = color
        setTitle(title, for: .normal)
    }
}
