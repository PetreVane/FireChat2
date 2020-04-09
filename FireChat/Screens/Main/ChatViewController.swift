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
    let storage = CloudStorage.shared
    var chatRoom: ChatRoom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.dismissKeyboardOnTap()
        showNoMessagesState()
        title = chatRoom?.title
    }
    
    private func showNoMessagesState() {
        chatMessages.count == 0 ? showEmptyState(withTitle: "Ops, no messages yet", message: "Start typing to add a new message!") : print("There are some messages left from yesterday dinner 🤭")
    }
    
    private func startChatRoom() {
        guard let existingChatRoom = chatRoom else { fatalError("No chatRoom assigned for this window")}
    }
    
}

extension ChatViewController {
    class func instantiate(delegate: ChatVCDelegate) -> ChatViewController {
        let viewController = ChatViewController()
        viewController.delegate = delegate
        return viewController
    }
}
