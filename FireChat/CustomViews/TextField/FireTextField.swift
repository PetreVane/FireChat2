//
//  FireTextField.swift
//  FireChat
//
//  Created by Petre Vane on 05/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

class FireTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTextField() {
        translatesAutoresizingMaskIntoConstraints = false
        
        //shape
        layer.cornerRadius = 10
        layer.borderWidth = 2
        
        //color
        layer.borderColor = UIColor.systemGray4.cgColor
        textColor = .label
        tintColor = .label
        
        //text allignment
        textAlignment = .center
        clearButtonMode = .whileEditing
        
        //font
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 9
        
        //background
        backgroundColor = .tertiarySystemBackground
        
        //placeHolder + autocorrect
        autocorrectionType = .no
        placeholder = "Type in your user name"
        
        
        // custom return key
        keyboardType = .default
        returnKeyType = .send
    }
    
}
