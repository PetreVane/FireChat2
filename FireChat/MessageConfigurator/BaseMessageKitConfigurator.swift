//
//  BaseMessageKitConfigurator.swift
//  FireChat
//
//  Created by Petre Vane on 06/04/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView


class BaseMessageKitConfigurator: MessagesViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    open lazy var audioController = AudioController(messageCollectionView: messagesCollectionView)
    let auth = FirebaseAuth.shared
    let cloudFirestore = CloudFirestore.shared
    let refreshController = UIRefreshControl()
    var chatMessages = [Message]()
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    var chatRoom: ChatRoom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageCollectionView()
        configureMessageInputBar()
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        audioController.stopAnyOngoingPlaying()
    }
    
    func configureMessageCollectionView() {
        // delegates
        messagesCollectionView.dataSource = self
        messagesCollectionView.delegate = self
        
        // other
        scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messagesCollectionView.addSubview(refreshController)
        refreshController.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .systemOrange
        messageInputBar.sendButton.setTitleColor(.systemOrange, for: .normal)
        messageInputBar.sendButton.setTitleColor(.systemRed, for: .highlighted)
    }
    
    @objc private func loadMoreMessages() {
        self.refreshController.endRefreshing()
    }
}


extension BaseMessageKitConfigurator: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        print("Image tapped")
    }
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom cell label tapped")
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }
    
    func didTapPlayButton(in cell: AudioMessageCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
            let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView)
            else { print("Failed to identify message when audio cell receive tap gesture"); return }
        
        guard audioController.state != .stopped
            else {
            // There is no audio sound playing - prepare to start playing for given audio message
            audioController.playSound(for: message, in: cell); return }
        
        if audioController.playingMessage?.messageId == message.messageId {
            // tap occur in the current cell that is playing audio sound
            if audioController.state == .playing {
                audioController.pauseSound(for: message, in: cell)
            } else { audioController.resumeSound() }
        } else {
            // tap occur in a difference cell that the one is currently playing sound. First stop currently playing and start the sound for given message
            audioController.stopAnyOngoingPlaying()
            audioController.playSound(for: message, in: cell)
        }
    }
    
    func didStartAudio(in cell: AudioMessageCell) {
        print("Did start playing audio sound")
    }
    
    func didPauseAudio(in cell: AudioMessageCell) {
        print("Did pause audio sound")
    }
    
    func didStopAudio(in cell: AudioMessageCell) {
        print("Did stop audio sound")
    }
    
    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }
}

extension BaseMessageKitConfigurator: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }
    
    func didSelectHashtag(_ hashtag: String) {
        print("Hashtag selected: \(hashtag)")
    }
    
    func didSelectMention(_ mention: String) {
        print("Mention selected: \(mention)")
    }
    
    func didSelectCustom(_ pattern: String, match: String?) {
        print("Custom data detector patter selected: \(pattern)")
    }
}

extension BaseMessageKitConfigurator: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        // Here we can parse for which substrings were autocompleted
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        
        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            self.insertMessages(components)
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    private func insertMessages(_ data: [Any]) {
        let currentlyLoggedInUser = auth.loggedInUser.first! // come back and change the forced unwrap
        
        for component in data {
            if let stringMessage = component as? String {
                let message = Message(text: stringMessage, user: currentlyLoggedInUser, messageID: UUID().uuidString, date: Date())
                cloudFirestore.upload(message: message, from: chatRoom!)
                
            } else if let imageMessage = component as? UIImage {
                let message = Message(image: imageMessage, user: currentlyLoggedInUser, messageID: UUID().uuidString, date: Date())
                cloudFirestore.upload(message: message, from: chatRoom!)
                
            } else if let audioMessage = component as? AudioItem {
                let message = Message(audioURL: audioMessage.url, user: currentlyLoggedInUser, messageID: UUID().uuidString, date: Date())
                cloudFirestore.upload(message: message, from: chatRoom!)
            }
        }
    }
}




/*
 Other methods that were included in example:
 - MockSocket.shared.connect(with: [SampleData.shared.Nathan, SampleData.shared.wu])
 - MockSocket.shared.disconnect()
 - loadFirstMessages()
 - loadMoreMessages()
 - configureMessageCollectionView()
 - insertMessage(_ message: MockMessage)
 - isLastSectionVisible() -> Bool
 
MARK: - MessagesDataSource
 
 - currentSender() -> SenderType
 - numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int
 - messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType
 - cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?
 - cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?
 - messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?
 - messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?
 
 */
