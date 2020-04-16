//
//  AdvancedExample.swift
//  FireChat
//
//  Created by Petre Vane on 13/04/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit
import MapKit
import MessageKit
import InputBarAccessoryView

//class AdvancedExample: BaseMessageKitConfigurator {
//
////     let outgoingAvatarOverlap: CGFloat = 17.5
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureMessageCollectionView()
//
//    }
//
//    override func configureMessageCollectionView() {
//
//    }
//
//    // MARK: - Helpers
//
//    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
//        return indexPath.section % 3 == 0 && !isPreviousMessageSameSender(at: indexPath)
//    }
//
//    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
//        guard indexPath.section - 1 >= 0 else { return false }
//        return chatMessages[indexPath.section].user == chatMessages[indexPath.section - 1].user
//    }
//
//    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
//        guard indexPath.section + 1 < chatMessages.count else { return false }
//        return chatMessages[indexPath.section].user == chatMessages[indexPath.section + 1].user
//    }
//
//    private func makeButton(named: String) -> InputBarButtonItem {
//        return InputBarButtonItem()
//            .configure {
//                $0.spacing = .fixed(10)
//                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
//                $0.setSize(CGSize(width: 25, height: 25), animated: false)
//                $0.tintColor = UIColor(white: 0.8, alpha: 1)
//            }.onSelected {
//                $0.tintColor = .systemBlue
//            }.onDeselected {
//                $0.tintColor = UIColor(white: 0.8, alpha: 1)
//            }.onTouchUpInside {
//                print("Item Tapped")
//                let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//                let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//                actionSheet.addAction(action)
//                if let popoverPresentationController = actionSheet.popoverPresentationController {
//                    popoverPresentationController.sourceView = $0
//                    popoverPresentationController.sourceRect = $0.frame
//                }
//                self.navigationController?.present(actionSheet, animated: true, completion: nil)
//        }
//    }
//
//
//    // MARK: - UICollectionViewDataSource
//    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
//            fatalError("Ouch. nil data source for messages")
//        }
//
//        // Very important to check this when overriding `cellForItemAt`
//        // Super method will handle returning the typing indicator cell
//        guard !isSectionReservedForTypingIndicator(indexPath.section) else {
//            return super.collectionView(collectionView, cellForItemAt: indexPath)
//        }
//
//        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
//        if case .custom = message.kind {
//            let cell = messagesCollectionView.dequeueReusableCell(ChatRoomCell.self, for: indexPath)
//            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
//            return cell
//        }
//        return super.collectionView(collectionView, cellForItemAt: indexPath)
//    }
//
//    // MARK: - MessagesDataSource
//
//    func currentSender() -> SenderType {
//        return auth.loggedInUser.first!
//    }
//
//    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
//        return chatMessages[indexPath.section]
//    }
//
//    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
//        return chatMessages.count
//    }
//
//    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//
//    if isTimeLabelVisible(at: indexPath) {
//        return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
//    }
//    return nil
//}
//
//    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        if !isPreviousMessageSameSender(at: indexPath) {
//            let name = message.sender.displayName
//            return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
//        }
//        return nil
//    }
//
//    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//
//        if !isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message) {
//            return NSAttributedString(string: "Delivered", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
//        }
//        return nil
//    }
//}

// MARK: - MessagesDisplayDelegate

//extension AdvancedExample: MessagesDisplayDelegate {
//    // MARK: - Text Messages
//
//    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        return isFromCurrentSender(message: message) ? .red : .darkText
//    }
//
//    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
//        switch detector {
//        case .hashtag, .mention:
//            if isFromCurrentSender(message: message) {
//                return [.foregroundColor: UIColor.blue]
//            } else {
//                return [.foregroundColor: UIColor.systemPink]
//            }
//        default: return MessageLabel.defaultAttributes
//        }
//    }
//
//    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
//        return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
//    }
//
//    // MARK: - All Messages
//
//    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        return isFromCurrentSender(message: message) ? .systemTeal : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
//    }
//
//    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
//
//        var corners: UIRectCorner = []
//
//        if isFromCurrentSender(message: message) {
//            corners.formUnion(.topLeft)
//            corners.formUnion(.bottomLeft)
//            if !isPreviousMessageSameSender(at: indexPath) {
//                corners.formUnion(.topRight)
//            }
//            if !isNextMessageSameSender(at: indexPath) {
//                corners.formUnion(.bottomRight)
//            }
//        } else {
//            corners.formUnion(.topRight)
//            corners.formUnion(.bottomRight)
//            if !isPreviousMessageSameSender(at: indexPath) {
//                corners.formUnion(.topLeft)
//            }
//            if !isNextMessageSameSender(at: indexPath) {
//                corners.formUnion(.bottomLeft)
//            }
//        }
//
//        return .custom { view in
//            let radius: CGFloat = 16
//            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//            let mask = CAShapeLayer()
//            mask.path = path.cgPath
//            view.layer.mask = mask
//        }
//    }
//
//    func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        // Cells are reused, so only add a button here once. For real use you would need to
//        // ensure any subviews are removed if not needed
//        accessoryView.subviews.forEach { $0.removeFromSuperview() }
//        accessoryView.backgroundColor = .clear
//
//        let shouldShow = Int.random(in: 0...10) == 0
//        guard shouldShow else { return }
//
//        let button = UIButton(type: .infoLight)
//        button.tintColor = UIColor.systemGreen
//        accessoryView.addSubview(button)
//        button.frame = accessoryView.bounds
//        button.isUserInteractionEnabled = false // respond to accessoryView tap through `MessageCellDelegate`
//        accessoryView.layer.cornerRadius = accessoryView.frame.height / 2
//        accessoryView.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.3)
//    }
//
//    // MARK: - Location Messages
//
//    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView? {
//        let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: nil)
//        let pinImage = #imageLiteral(resourceName: "ic_map_marker")
//        annotationView.image = pinImage
//        annotationView.centerOffset = CGPoint(x: 0, y: -pinImage.size.height / 2)
//        return annotationView
//    }
//
//    func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)? {
//        return { view in
//            view.layer.transform = CATransform3DMakeScale(2, 2, 2)
//            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
//                view.layer.transform = CATransform3DIdentity
//            }, completion: nil)
//        }
//    }
//
//    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {
//
//        return LocationMessageSnapshotOptions(showsBuildings: true, showsPointsOfInterest: true, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
//    }
//
//    // MARK: - Audio Messages
//
//    func audioTintColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        return self.isFromCurrentSender(message: message) ? .white : .systemYellow
//    }
//
//    func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
//        audioController.configureAudioCell(cell, message: message) // this is needed especily when the cell is reconfigure while is playing sound
//    }
//
//}

// MARK: - MessagesLayoutDelegate

//extension AdvancedExample: MessagesLayoutDelegate {
//
//    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        if isTimeLabelVisible(at: indexPath) {
//            return 18
//        }
//        return 0
//    }
//
//    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        if isFromCurrentSender(message: message) {
//            return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
//        } else {
//            return !isPreviousMessageSameSender(at: indexPath) ? (20 + 2) : 0
//        } // outgoingAvatarOverlap
//    }
//
//    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return (!isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message)) ? 16 : 0
//    }
//
//}

//    func setTypingIndicatorViewHidden(_ isHidden: Bool, performUpdates updates: (() -> Void)? = nil) {
//        updateTitleView(title: "MessageKit", subtitle: isHidden ? "2 Online" : "Typing...")
//        setTypingIndicatorViewHidden(isHidden, animated: true, whilePerforming: updates) { [weak self] success in
//            if success, self?.isLastSectionVisible() == true {
//                self?.messagesCollectionView.scrollToBottom(animated: true)
//            }
//        }
//    }

//    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        let avatar = SampleData.shared.getAvatarFor(sender: message.sender)
//        avatarView.set(avatar: avatar)
//        avatarView.isHidden = isNextMessageSameSender(at: indexPath)
//        avatarView.layer.borderWidth = 2
//        avatarView.layer.borderColor = UIColor.systemRed.cgColor
//    }
