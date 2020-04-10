//
//  Message.swift
//  FireChat
//
//  Created by Petre Vane on 04/04/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import Foundation
import CoreLocation
import AVFoundation
import MessageKit

class Message: MessageType {
    
    var user: User
    var sender: SenderType { return user }
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    /// Points to a resource associated with this Message
    var messageDataURL: URL?
    
    private init(kind: MessageKind, user: User, messageID: String, date: Date) {
        self.kind = kind
        self.user = user
        self.messageId = messageID
        self.sentDate = date
    }
    
    convenience init(custom: Any, user: User, messageID: String, date: Date) {
        self.init(kind: .custom(custom), user: user, messageID: messageID, date: date)
    }
     
    convenience init(text: String, user: User, messageID: String, date: Date) {
        self.init(kind: .text(text), user: user, messageID: messageID, date: date)
    }
    
    convenience init(attributedText: NSAttributedString, user: User, messageID: String, date: Date) {
        self.init(kind: .attributedText(attributedText), user: user, messageID: messageID, date: date)
    }
    
    convenience init(image: UIImage, user: User, messageID: String, date: Date) {
        let mediaItem = ImageMediaItem(image: image)
        self.init(kind: .photo(mediaItem), user: user, messageID: messageID, date: date)
    }
    
    convenience init(thumbnail: UIImage, user: User, messageID: String, date: Date) {
        let mediaItem = ImageMediaItem(image: thumbnail)
        self.init(kind: .video(mediaItem), user: user, messageID: messageID, date: date)
    }
    
    convenience init(location: CLLocation, user: User, messageID: String, date: Date) {
        let locationItem = CoordinateItem(location: location)
        self.init(kind: .location(locationItem), user: user, messageID: messageID, date: date)
    }
    
    convenience init(emoji: String, user: User, messageID: String, date: Date) {
        self.init(kind: .emoji(emoji), user: user, messageID: messageID, date: date)
    }
    
    convenience init(audioURL: URL, user: User, messageID: String, date: Date) {
        let audioItem = SoundItem(url: audioURL)
        self.init(kind: .audio(audioItem), user: user, messageID: messageID, date: date)
    }
    
    convenience init(contactItem: Contact, user: User, messageID: String, date: Date) {
        self.init(kind: .contact(contactItem), user: user, messageID: messageID, date: date)
    }
}

extension Message: Comparable {
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate == rhs.sentDate
    }
}

private struct ImageMediaItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
}

private struct CoordinateItem: LocationItem {
    var location: CLLocation
    var size: CGSize
    
    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
}

private struct SoundItem: AudioItem {
    var url: URL
    var duration: Float
    var size: CGSize
    
    init(url: URL) {
        self.url = url
        self.size = CGSize(width: 160, height: 35)
        let audioAsset = AVURLAsset(url: url)
        self.duration = Float(CMTimeGetSeconds(audioAsset.duration))
    }
}

 struct Contact: ContactItem {
    var displayName: String
    var initials: String
    var phoneNumbers: [String]
    var emails: [String]
    
    init(name: String, initials: String, phoneNumbers: [String] = [], emails: [String] = []) {
        self.displayName = name
        self.initials = initials
        self.phoneNumbers = phoneNumbers
        self.emails = emails
    }
}

