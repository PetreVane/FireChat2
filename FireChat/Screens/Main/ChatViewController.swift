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

class ChatViewController: BaseConfiguration {

    weak var delegate: ChatVCDelegate?
    var currentlyLoggedInUser: User?
//    var chatRoom: ChatRoom?
//    var chatMessages: [Message] = []
    
    // firebase
//    let auth = FirebaseAuth.shared
//    let cloudFirestore = CloudFirestore.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageCollectionView()
        view.backgroundColor = .systemBackground
        confirmChatRoomDetails()
        view.dismissKeyboardOnTap()
        fetchMessages(for: chatRoom)
    }
    
    //MARK: - Private methods
        
    private func confirmChatRoomDetails() {
        guard let currentUser = auth.loggedInUser.first else { return }
        currentlyLoggedInUser = currentUser
        guard chatRoom != nil else { return }
    }
    
  
    private func showNoMessagesState() {
        chatMessages.count == 0 ? showEmptyState(withTitle: "Ops, no messages yet", message: "Start typing to add a new message!") : print("There are some messages to be shown! 🤭")
    }
    
    
    private func fetchMessages(for chatRoom: ChatRoom?) {
        guard let currentChatRoom = chatRoom else { return }
        cloudFirestore.fetchLatestMessages(for: currentChatRoom) { [weak self] (result) in
            guard let self = self else { return }

            switch result {
                case .failure(let error):
                    self.presentAlert(withTitle: "Ops, an Error", message: error.rawValue, buttonTitle: "Dismiss")
                case .success(let messages):
                    self.parse(chatMessages: messages, for: currentChatRoom)
            }
        }
    }
    
    private func parse(chatMessages: Dictionary<ChatRoom, [Message]>, for chatRoom: ChatRoom) {
        if let messages = chatMessages[chatRoom] {
            for chatMessage in messages {
                guard !self.chatMessages.contains(chatMessage) else { return }
                self.chatMessages.insert(chatMessage, at: 0)
                self.chatMessages.sort { $0.sentDate < $1.sentDate }
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem()
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

extension ChatViewController: ImagePickerDelegate {
    func didSelect(image: UIImage) {
        print("Image has been selected")
    }
}



