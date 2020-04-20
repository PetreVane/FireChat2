//
//  BaseConfiguration.swift
//  FireChat
//
//  Created by Petre Vane on 17/04/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit
import MessageKit
import MapKit
import InputBarAccessoryView


class BaseConfiguration: MessagesViewController, MessagesDataSource {
    
    // Firebase
    var chatMessages = [Message]()
    var chatRoom: ChatRoom?
    let auth = FirebaseAuth.shared
    let cloudFirestore = CloudFirestore.shared
    let outgoingAvatarOverlap: CGFloat = 17.5
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    /// The `BasicAudioController` controll the AVAudioPlayer state (play, pause, stop) and udpate audio cell UI accordingly.
    open lazy var audioController = AudioController(messageCollectionView: messagesCollectionView)
    
    let refreshControl = UIRefreshControl()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMessageCollectionView()
        configureMessageInputBar()
        title = "MessageKit"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // mock something
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        audioController.stopAnyOngoingPlaying()
    }
    
    
    func configureMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
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
        let bottomItems = [.flexibleSpace, makeCharCounter()]
        messageInputBar.middleContentViewPadding.bottom = 8
        messageInputBar.setStackViewItems(bottomItems, forStack: .bottom, animated: false)
        
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
        cameraButton.onTouchUpInside { _ in print("Camera button tapped") }
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
    
    @objc private func didPullToRefresh() {
        print("User pulled to refresh")
    }
    
// MARK: - Helpers
        
    func isLastSectionVisible() -> Bool {
        
        guard !chatMessages.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: chatMessages.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
           return indexPath.section % 3 == 0 && !isPreviousMessageSameSender(at: indexPath)
       }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
         guard indexPath.section - 1 >= 0 else { return false }
         return chatMessages[indexPath.section].user == chatMessages[indexPath.section - 1].user
     }

     func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
         guard indexPath.section + 1 < chatMessages.count else { return false }
         return chatMessages[indexPath.section].user == chatMessages[indexPath.section + 1].user
     }

     func setTypingIndicatorViewHidden(_ isHidden: Bool, performUpdates updates: (() -> Void)? = nil) {
//         updateTitleView(title: "MessageKit", subtitle: isHidden ? "2 Online" : "Typing...")
         setTypingIndicatorViewHidden(isHidden, animated: true, whilePerforming: updates) { [weak self] success in
             if success, self?.isLastSectionVisible() == true {
                 self?.messagesCollectionView.scrollToBottom(animated: true)
             }
         }
    }

// MARK: - MessagesDataSource
    
    func currentSender() -> SenderType {
        return auth.loggedInUser.first! //SampleData.shared.currentSender
    }
    
    func isFromCurrentSender(message: MessageType) -> Bool {
         return message.sender.displayName == currentSender().displayName
     }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatMessages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return chatMessages[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(string: "Delivered", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = isFromCurrentSender(message: message) ? "You wrote:  " : "\(message.sender.displayName) wrote:"
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
}

// MARK: - MessageCellDelegate

extension BaseConfiguration: MessageCellDelegate {
    
    func didTapPlayButton(in cell: AudioMessageCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
            let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                print("Failed to identify message when audio cell receive tap gesture")
                return
        }
        guard audioController.state != .stopped else {
            // There is no audio sound playing - prepare to start playing for given audio message
            audioController.playSound(for: message, in: cell)
            return
        }
        if audioController.playingMessage?.messageId == message.messageId {
            // tap occur in the current cell that is playing audio sound
            if audioController.state == .playing {
                audioController.pauseSound(for: message, in: cell)
            } else {
                audioController.resumeSound()
            }
        } else {
            // tap occur in a difference cell that the one is currently playing sound. First stop currently playing and start the sound for given message
            audioController.stopAnyOngoingPlaying()
            audioController.playSound(for: message, in: cell)
        }
    }
}

// MARK: - MessageLabelDelegate

extension BaseConfiguration: MessageLabelDelegate { }

//MARK: - MessageDisplayDelegate

extension BaseConfiguration: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
          return isFromCurrentSender(message: message) ? .white : .white
      }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        switch detector {
            case .hashtag, .mention:
                if isFromCurrentSender(message: message) { return [.foregroundColor: UIColor.white] }
                else { return [.foregroundColor: UIColor.yellow] }
            default: return MessageLabel.defaultAttributes
        }
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
         return isFromCurrentSender(message: message) ? .systemBlue : .systemOrange
     }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tail, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        var avatarImage: UIImage? = nil
        if let imageURL = chatMessages[indexPath.section].user.photoURL {
            if let imageData = try? Data(contentsOf: imageURL) {
                let image = UIImage(data: imageData)
                avatarImage = image
            }
        }
        let avatar = Avatar(image: avatarImage, initials: "AV")
        avatarView.set(avatar: avatar)
        avatarView.isHidden = isNextMessageSameSender(at: indexPath)
        avatarView.layer.borderWidth = 2
        avatarView.layer.borderColor = UIColor.orange.cgColor
    }
    
    func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        // Cells are reused, so only add a button here once. For real use you would need to
        // ensure any subviews are removed if not needed
        accessoryView.subviews.forEach { $0.removeFromSuperview() }
        accessoryView.backgroundColor = .clear

        let shouldShow = Int.random(in: 0 ... 10) == 0
        guard shouldShow else { return }

        let button = UIButton(type: .infoLight)
        button.tintColor = .systemOrange
        accessoryView.addSubview(button)
        button.frame = accessoryView.bounds
        button.isUserInteractionEnabled = false // respond to accessoryView tap through `MessageCellDelegate`
        accessoryView.layer.cornerRadius = accessoryView.frame.height / 2
        accessoryView.backgroundColor = UIColor.green.withAlphaComponent(0.3)
    }

    
    // MARK: - Location Messages
    
    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: nil)
        let pinImage = Images.pin
        annotationView.image = pinImage
        annotationView.centerOffset = CGPoint(x: 0, y: -pinImage.size.height / 2)
        return annotationView
    }
    
    func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)? {
        return { view in
            view.layer.transform = CATransform3DMakeScale(2, 2, 2)
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                view.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
    }
    
    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {
        
        return LocationMessageSnapshotOptions(showsBuildings: true, showsPointsOfInterest: true, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    }
    
    // MARK: - Audio Messages
    
    func audioTintColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : UIColor(red: 15 / 255, green: 135 / 255, blue: 255 / 255, alpha: 1.0)
    }
    
    func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
        audioController.configureAudioCell(cell, message: message) // this is needed especily when the cell is reconfigure while is playing sound
    }
}

// MARK: - MessagesLayoutDelegate

extension BaseConfiguration: MessagesLayoutDelegate {

    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isTimeLabelVisible(at: indexPath) { return 18 }
        return 0
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 17
    }

    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isFromCurrentSender(message: message) {
            return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
        } else {
            return !isPreviousMessageSameSender(at: indexPath) ? (20 + outgoingAvatarOverlap) : 0
        }
    }

    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return (!isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message)) ? 16 : 0
    }
}

// MARK: - MessageInputBarDelegate

extension BaseConfiguration: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
                
        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        
        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToLastItem() //scrollToBottom(animated: true)
            }
        }
    }
    
    private func insertMessages(_ data: [Any]) {
        for component in data {
            let user = auth.loggedInUser.first!
                
            if let str = component as? String {
                let message = Message(text: str, user: user, messageID: UUID().uuidString, date: Date())
                cloudFirestore.upload(message: message, from: chatRoom!)
            } else if let img = component as? UIImage {
                let message = Message(image: img, user: user, messageID: UUID().uuidString, date: Date())
                cloudFirestore.upload(message: message, from: chatRoom!)
            }
        }
    }
}


