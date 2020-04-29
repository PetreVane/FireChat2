//
//  ChatViewController.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView


protocol ChatVCDelegate: AnyObject { }

class ChatViewController: BaseConfiguration {

    weak var delegate: ChatVCDelegate?
    var currentlyLoggedInUser: User?
    var chatRoom: ChatRoom?
    private var tokens: [String] = []
    
    let refreshControl = UIRefreshControl()
    let cloudFirestore = CloudFirestore.shared
    let notificationsManager = PushNotificationsManager.shared
    var imagePicker: ImagePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cloudFirestore.delegate = self
        title = chatRoom?.title
        configureMessageCollectionView()
        configureMessageInputBar()
        configureImagePicker()
        confirmChatRoomDetails()
        view.dismissKeyboardOnTap()
        fetchMessages(for: chatRoom, mostRecent: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messagesCollectionView.scrollToLastItem()
        fetchTokens()
    }

    // MARK: - Configuration methods
    override func configureMessageCollectionView() {
        super.configureMessageCollectionView()
        messagesCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.sendButton.setTitleColor(UIColor.systemBlue, for: .normal)
        messageInputBar.sendButton.setTitleColor( UIColor.systemOrange, for: .highlighted)
        
        //         Additional settings:
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.tintColor = .systemBlue
        messageInputBar.inputTextView.textColor = .darkGray
        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200 / 255, green: 200 / 255, blue: 200 / 255, alpha: 1).cgColor
        messageInputBar.inputTextView.layer.borderWidth = 0.5 // 1
        messageInputBar.inputTextView.layer.cornerRadius = 6.0 // 16
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        configureInputBarItems()
    }
    
    private func configureInputBarItems() {
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.sendButton.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        messageInputBar.sendButton.image = Images.arrow// arrow image
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 16
        messageInputBar.middleContentViewPadding.right = -38
        
        // bottom right items
    //        let bottomItems = [.flexibleSpace, makeCharCounter()]
    //        messageInputBar.middleContentViewPadding.bottom = 8
    //        messageInputBar.setStackViewItems(bottomItems, forStack: .bottom, animated: false)
        
        // left items
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.setStackViewItems([makeCameraButton(named: "Camera")], forStack: .left, animated: false)
        
        // This just adds some more flare
        messageInputBar.sendButton
            .onEnabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    item.imageView?.backgroundColor = .orange
                })
        }.onDisabled { item in
            UIView.animate(withDuration: 0.3, animations: {
                item.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
            })
        }
    }

    private func makeCameraButton(named: String) -> InputBarButtonItem {
        let cameraButton = InputBarButtonItem()
        cameraButton.configure { button in
            button.spacing = .fixed(10)
            button.image = UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate)
            button.setSize(CGSize(width: 25, height: 25), animated: false)
            button.tintColor = UIColor(white: 0.8, alpha: 1)
        }
        cameraButton.onSelected { $0.tintColor = .systemOrange }
        cameraButton.onDeselected { $0.tintColor = UIColor(white: 0.8, alpha: 1)}
        cameraButton.onTouchUpInside { button in
            self.imagePicker?.presentAlert(from: button)
        }
        
        return cameraButton
    }
       
    private func makeCharCounter() -> InputBarButtonItem {
        let characterCounter = InputBarButtonItem()
        characterCounter.configure { label in
            label.title = "0/140"
            label.contentHorizontalAlignment = .right
            label.setTitleColor(UIColor(white: 0.6, alpha: 1), for: .normal)
            label.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .bold)
            label.setSize(CGSize(width: 50, height: 25), animated: false)
        }
        characterCounter.onTextViewDidChange { (item, textView) in
            item.title = "\(textView.text.count)/140"
            let isOverLimit = textView.text.count > 140
            item.inputBarAccessoryView?.shouldManageSendButtonEnabledState = !isOverLimit
            // Disable automated management when over limit
            if isOverLimit { item.inputBarAccessoryView?.sendButton.isEnabled = false }
            let color = isOverLimit ? .red : UIColor(white: 0.6, alpha: 1)
            item.setTitleColor(color, for: .normal)
        }
        return characterCounter
    }
    
    private func configureImagePicker() {
        imagePicker = ImagePicker(presentingController: self, delegate: self)
    }
       
    
    //MARK: - Private methods
    
    @objc private func didPullToRefresh() {
        fetchMessages(for: chatRoom, mostRecent: false)
        shouldReloadMessages(mostRecent: false)
    }
        
    private func confirmChatRoomDetails() {
        guard let currentUser = auth.loggedInUser.first else { return }
        currentlyLoggedInUser = currentUser
        guard chatRoom != nil else { return }
    }
    
  
    private func showNoMessagesState() {
        messages.count == 0 ? showEmptyState(withTitle: "Ops, no messages yet", message: "Start typing to add a new message!") : print("There are some messages to be shown! 🤭")
    }
    
    
    private func fetchMessages(for chatRoom: ChatRoom?, mostRecent: Bool) {
        guard let currentChatRoom = chatRoom else { return }
        cloudFirestore.fetchMessages(for: currentChatRoom, requestedMostRecent: mostRecent) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .failure(let error):
                    self.presentAlert(withTitle: "Ops, an Error", message: error.rawValue, buttonTitle: "Dismiss")
                case .success(let messages):
                    self.parse(chatMessages: messages, for: currentChatRoom)
                    self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func parse(chatMessages: Dictionary<ChatRoom, [Message]>, for chatRoom: ChatRoom) {
        if let fetchedMessages = chatMessages[chatRoom] {
            for chatMessage in fetchedMessages {
                guard !self.messages.contains(chatMessage) else { return }
                self.messages.insert(chatMessage, at: 0)
                self.messages.sort { $0.sentDate < $1.sentDate }
                DispatchQueue.main.async { self.messagesCollectionView.reloadData() }
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

// MARK: - ImagePicker delegate
extension ChatViewController: ImagePickerDelegate {
    func didSelect(image: UIImage) {
        let message = Message(image: image, user: currentlyLoggedInUser!, messageID: UUID().uuidString, date: Date())
        cloudFirestore.upload(message: message, from: chatRoom!)
        print("Image has been selected and upload triggered")
    }
}

extension ChatViewController: CloudFirebaseDelegate {
    func shouldReloadMessages(mostRecent: Bool) {
        switch mostRecent {
            case true:
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem() }
            case false: DispatchQueue.main.async { self.messagesCollectionView.reloadData() }
        }
    }
}

// MARK: - InputBarAccessoryViewDelegate
extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        
        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components)
            }
        }
    }
    
    private func insertMessages(_ data: [Any]) {
        for component in data {
            let user = auth.loggedInUser.first!
            if let str = component as? String {
                let message = Message(text: str, user: user, messageID: UUID().uuidString, date: Date())
                cloudFirestore.upload(message: message, from: chatRoom!)
                for token in tokens {
                    notificationsManager.sendPushNotification(to: token, title: "\(user.displayName) said:", body: str)
                }
                
            } else if let img = component as? UIImage {
                let message = Message(image: img, user: user, messageID: UUID().uuidString, date: Date())
                cloudFirestore.upload(message: message, from: chatRoom!)
            }
        }
        shouldReloadMessages(mostRecent: true)
    }
}

// MARK: - Notifications

extension ChatViewController {
    
    private func fetchTokens() {
        cloudFirestore.retrieveTokens {[weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let errors):
                print("Failed fetching tokens: \(errors)")
                
            case .success(let token):
                print("Fetched token is \(token)")
                self.tokens.append(token)
            }
        }
    }
    
}



