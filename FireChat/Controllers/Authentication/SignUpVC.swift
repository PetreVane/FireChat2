//
//  SignUpVC.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

protocol SignUPDelegate: AnyObject {
    
}

class SignUpVC: UIViewController {
    
    weak var delegate: SignUPDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
}

extension SignUpVC {
    
    class func instantiate(delegate: SignUPDelegate) -> SignUpVC {
        let viewController = SignUpVC()
        viewController.delegate = delegate
        return viewController
    }
}


