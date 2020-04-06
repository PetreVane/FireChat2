//
//  ChatViewController.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

protocol ChatVCDelegate: AnyObject {
    
}

class ChatViewController: UIViewController {

    weak var delegate: ChatVCDelegate?
    var chatMessages = [String]()
//    let firebaseMessages = FirebaseMessagesController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.dismissKeyboardOnTap()
        showNoMessagesState()
        title = "Chat View Controller"
    }
    
    private func showNoMessagesState() {
        chatMessages.count == 0 ? showEmptyState(withTitle: "Ops, no messages yet", message: "Start typing to add a new message!") : print("There are some messages left from yesterday dinner 🤭")
    }
    
}

extension ChatViewController {
    class func instantiate(delegate: ChatVCDelegate) -> ChatViewController {
        let viewController = ChatViewController()
        viewController.delegate = delegate
        return viewController
    }
}
