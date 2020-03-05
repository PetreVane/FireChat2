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
}
