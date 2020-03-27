//
//  ChannelsViewController.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

protocol ChannelsVCDelegate: AnyObject {
    // didPressChatCell -> init ChatVC
}

class ChannelsViewController: UIViewController {
    
    weak var delegate: ChannelsVCDelegate?
    private let label = FireLabel(textAlignment: .center, fontSize: 25)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
//        configureLabel()
        showEmptyState()
    }
    
    private func configureLabel() {
        view.addSubview(label)
        label.text = "Welcome to Channels ViewController"
        let padding: CGFloat = 50
        label.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
        
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            label.heightAnchor.constraint(equalToConstant: padding)
        ])
    }
    
}

extension ChannelsViewController {
    class func instantiate(delegate: ChannelsVCDelegate) -> ChannelsViewController {
        let viewController = ChannelsViewController()
        viewController.delegate = delegate
        return viewController
    }
}

