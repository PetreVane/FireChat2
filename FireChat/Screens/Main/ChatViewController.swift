//
//  ChatViewController.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit
import MessageKit

protocol ChatVCDelegate: AnyObject { }

class ChatViewController: AdvancedExample {

    weak var delegate: ChatVCDelegate?
    var currentlyLoggedInUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        confirmChatRoomDetails()
        view.dismissKeyboardOnTap()
        title = chatRoom?.title
        fetchMessages()
    }
    
    //MARK: - Private methods
    
    private func confirmChatRoomDetails() {
        guard let currentUser = auth.loggedInUser.first else { return }
        currentlyLoggedInUser = currentUser
        guard chatRoom != nil else { return }
    }
    
  
    private func showNoMessagesState() {
        chatMessages.count == 0 ? showEmptyState(withTitle: "Ops, no messages yet", message: "Start typing to add a new message!") : print("There are some more messages left! 🤭")
    }
    
    private func fetchMessages() {
        guard let currentChatRoom = chatRoom else { return }
        cloudFirestore.fetchLatestMessages(for: currentChatRoom) { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case .failure(let error):
                self.presentAlert(withTitle: "Ops, an Error", message: error.rawValue, buttonTitle: "Dismiss")

            case .success(let messages):
                print("You've got \(messages.count) received messages from completionHandler")
                
                for message in messages {
                    guard !self.chatMessages.contains(message) else { return }
                    self.chatMessages.append(message)
    
                    switch message.kind {
                        case .text(let text): print("Your message text is: \(text) sent on \(message.sentDate)")
                        default: print("Other type of message")
                    }
                }
            }
        }
    }
}

extension ChatViewController {
    class func instantiate(delegate: ChatVCDelegate) -> ChatViewController {
        let viewController = ChatViewController()
        viewController.delegate = delegate
        return viewController
    }
}




