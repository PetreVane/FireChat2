//
//  TableView+Ext.swift
//  FireChat
//
//  Created by Petre Vane on 30/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit


extension UITableView {
    
    /// Removes empty cells from TableView
    func removeEmptyCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
