//
//  UIView+Ext.swift
//  FireChat
//
//  Created by Petre Vane on 05/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

extension UIView {
    
    func addCustomView(_ views: UIView...) {
        for customView in views {
            addSubview(customView)
        }
    }
    
    func dismissKeyboardOnTap() {
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing(_:)))
          self.addGestureRecognizer(tapGesture)
      }
}
