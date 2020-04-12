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
    var chatMessages = [Message]()
    let auth = FirebaseAuth.shared
    let database = CloudFirestore.shared
    let storage = CloudStorage.shared
    var chatRoom: ChatRoom?
    private let fetchMessagesNow = FireButton(backgroundColor: .systemRed, title: "Fetch Messages")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.dismissKeyboardOnTap()
        title = chatRoom?.title
        configureButton()
        fetchMessages()
//        sendTestMessage(in: chatRoom)
//        sendTestImageMessage(in: chatRoom)
    }
    
    
    //MARK: - Private methods
    
    
    private func configureButton() {
        let padding: CGFloat = 50
        view.addSubview(fetchMessagesNow)
        fetchMessagesNow.addTarget(self, action: #selector(didPressFetchMessages), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            fetchMessagesNow.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            fetchMessagesNow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            fetchMessagesNow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            fetchMessagesNow.heightAnchor.constraint(equalToConstant: padding)
        ])
    }
    
    @objc private func didPressFetchMessages() {
        fetchMessages()
    }
    
    private func showNoMessagesState() {
        chatMessages.count == 0 ? showEmptyState(withTitle: "Ops, no messages yet", message: "Start typing to add a new message!") : print("There are some messages left from yesterday dinner 🤭")
    }
    
    private func sendTestMessage(in chatRoom: ChatRoom?) {
        guard let currentChatRoom = chatRoom else { return }
        guard let currentUser = auth.loggedInUser.first else { return }
        let currentDate = Date()
        let testMessage = Message(text: "This is a test Message", user: currentUser, messageID: "", date: currentDate)
        database.upload(message: testMessage, from: currentChatRoom)
    }
    
    private func sendTestImageMessage(in chatRoom: ChatRoom?) {
        guard let currentChatRoom = chatRoom else { return }
        let testUser = User(name: "Petre", email: "SecretEmail", photoURL: nil, provider: "\(currentChatRoom.title)")
        let currentDate = Date()
        guard let testImage = Images.noMessages else { return }
        let testImageMessage = Message(image: testImage, user: testUser, messageID: "First test Image", date: currentDate)
        database.upload(message: testImageMessage, from: currentChatRoom)

    }
    
    private func fetchMessages() {
        guard let currentChatRoom = chatRoom else { return }
        database.fetchLatestMessages(for: currentChatRoom) { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case .failure(let error):
                self.presentAlert(withTitle: "Ops, an Error", message: error.rawValue, buttonTitle: "Dismiss")

            case .success(let messages):
                self.chatMessages.append(contentsOf: messages)
                print("You've got \(self.chatMessages.count) final messages")
                for message in messages {
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
