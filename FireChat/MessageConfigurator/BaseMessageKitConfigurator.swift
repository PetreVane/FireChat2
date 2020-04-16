//
//  BaseMessageKitConfigurator.swift
//  FireChat
//
//  Created by Petre Vane on 06/04/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit
import MessageKit
import MapKit
import InputBarAccessoryView


class BaseMessageKitConfigurator: MessagesViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    open lazy var audioController = AudioController(messageCollectionView: messagesCollectionView)
 
    let refreshController = UIRefreshControl()
    let outgoingAvatarOverlap: CGFloat = 17.5
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var chatMessages = [Message]()
    var chatRoom: ChatRoom?
    let auth = FirebaseAuth.shared
    let cloudFirestore = CloudFirestore.shared
    
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
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDataSource = self
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

extension BaseMessageKitConfigurator {
    // MARK: - Helpers
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
    
    private func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 25, height: 25), animated: false)
                $0.tintColor = UIColor(white: 0.8, alpha: 1)
        }.onSelected {
            $0.tintColor = .systemBlue
        }.onDeselected {
            $0.tintColor = UIColor(white: 0.8, alpha: 1)
        }.onTouchUpInside {
            print("Item Tapped")
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            actionSheet.addAction(action)
            if let popoverPresentationController = actionSheet.popoverPresentationController {
                popoverPresentationController.sourceView = $0
                popoverPresentationController.sourceRect = $0.frame
            }
            self.navigationController?.present(actionSheet, animated: true, completion: nil)
        }
    }
}

//MARK: - MessageCellDelegate

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
//MARK: - MessageLabelDelegate

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

//MARK: - InputBarAccessoryViewDelegate

extension BaseMessageKitConfigurator: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        // Here we can parse for which substrings were autocompleted
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            
//            let substring = attributedText.attributedSubstring(from: range)
//            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
//            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        
        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
//            sleep(1)
            self.insertMessages(components)
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.messagesCollectionView.scrollToLastItem()
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

//MARK: - MessagesDisplayDelegate

extension BaseMessageKitConfigurator: MessagesDisplayDelegate {
    // MARK: - Text Messages
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .red : .darkText
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        switch detector {
        case .hashtag, .mention:
            if isFromCurrentSender(message: message) {
                return [.foregroundColor: UIColor.blue]
            } else {
                return [.foregroundColor: UIColor.systemPink]
            }
        default: return MessageLabel.defaultAttributes
        }
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
    }
    
    // MARK: - All Messages
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .systemTeal : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        var corners: UIRectCorner = []
        
        if isFromCurrentSender(message: message) {
            corners.formUnion(.topLeft)
            corners.formUnion(.bottomLeft)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topRight)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomRight)
            }
        } else {
            corners.formUnion(.topRight)
            corners.formUnion(.bottomRight)
            if !isPreviousMessageSameSender(at: indexPath) {
                corners.formUnion(.topLeft)
            }
            if !isNextMessageSameSender(at: indexPath) {
                corners.formUnion(.bottomLeft)
            }
        }
        
        return .custom { view in
            let radius: CGFloat = 16
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
        }
    }
    
    func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        // Cells are reused, so only add a button here once. For real use you would need to
        // ensure any subviews are removed if not needed
        accessoryView.subviews.forEach { $0.removeFromSuperview() }
        accessoryView.backgroundColor = .clear
        
        let shouldShow = Int.random(in: 0...10) == 0
        guard shouldShow else { return }
        
        let button = UIButton(type: .infoLight)
        button.tintColor = UIColor.systemGreen
        accessoryView.addSubview(button)
        button.frame = accessoryView.bounds
        button.isUserInteractionEnabled = false // respond to accessoryView tap through `MessageCellDelegate`
        accessoryView.layer.cornerRadius = accessoryView.frame.height / 2
        accessoryView.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.3)
    }
    
    // MARK: - Location Messages
    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: nil)
        let pinImage = #imageLiteral(resourceName: "ic_map_marker")
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
        return self.isFromCurrentSender(message: message) ? .white : .systemYellow
    }
    
    func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
        audioController.configureAudioCell(cell, message: message) // this is needed especily when the cell is reconfigure while is playing sound
    }
}

//MARK: - MessagesLayoutDelegate

extension BaseMessageKitConfigurator: MessagesLayoutDelegate {
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isTimeLabelVisible(at: indexPath) {
            return 18
        }
        return 0
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

//MARK: - MessagesDataSource

extension BaseMessageKitConfigurator: MessagesDataSource {
    func currentSender() -> SenderType {
        return auth.loggedInUser.first!
    }
    
    func isFromCurrentSender(message: MessageType) -> Bool {
        return message.sender.displayName == currentSender().displayName
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return chatMessages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatMessages.count
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if isTimeLabelVisible(at: indexPath) {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if !isPreviousMessageSameSender(at: indexPath) {
            let name = message.sender.displayName
            return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        }
        return nil
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if !isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message) {
            return NSAttributedString(string: "Delivered", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        }
        return nil
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
 
    - MessagesDataSource
 
 - currentSender() -> SenderType
 - numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int
 - messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType
 - cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?
 - cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?
 - messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?
 - messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?
 
 */
