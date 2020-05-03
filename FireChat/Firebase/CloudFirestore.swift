//
//  CloudFirestore.swift
//  FireChat
//
//  Created by Petre Vane on 01/04/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

protocol CloudFirebaseDelegate: AnyObject {
    func shouldReloadMessages(mostRecent: Bool)
}

final class CloudFirestore {
    
    static let shared = CloudFirestore()
    private let cache = CacheManager.sharedInstance
    private let chatRooms = Firestore.firestore().collection(Collection.chatRooms)
    private let tokenDatabase = Firestore.firestore().collection(Collection.tokens)
    private lazy var cloudStorage = CloudStorage.shared
    private let auth = FirebaseAuth.shared
    var lastSnapshotForChatRoom: Dictionary<ChatRoom, [QueryDocumentSnapshot]> = [:]
    var messagesForChatRoom: Dictionary<ChatRoom, [Message]> = [:]
    weak var delegate: CloudFirebaseDelegate?
    
    
    //MARK: - Chat rooms
    
    func fetchChatRooms(completion: @escaping (Result<ChatRoom, ErrorsManager>) -> Void) {

        chatRooms.getDocuments { (snapShot, error) in
            guard error == nil else { completion(.failure(ErrorsManager.failedFetchingChatRooms)); return }
            
            _ = snapShot?.documents.map({ (document) in
                
                let channelName = document.documentID
                let documentContent = document.data()
                
                documentContent.forEach { (key, _) in
                    if let channelDescription = documentContent[key] as? String {
                        let chatRoom = ChatRoom(title: channelName, description: channelDescription)
                        completion(.success(chatRoom))
                    } else { completion(.failure(ErrorsManager.failedFetchingChatRooms)) }
                }
            })
        }
    }
    
    func createChatRoom(_ chatRoom: ChatRoom) {
        let documentTitle = chatRoom.title
        let documentData = ["Description": chatRoom.description]
        chatRooms.document(documentTitle).setData(documentData, merge: true)
    }
    
    func deleteChatRoom(_ channel: ChatRoom, completion: @escaping (Result<Bool, ErrorsManager>) -> Void) {
        chatRooms.document(channel.title).delete { (error) in
            guard error == nil else { completion(.failure(ErrorsManager.failedDeletingChatRoom)); return }
            completion(.success(true))
        }
    }
    
    
    //MARK: - Device Tokens
    
    func saveToken(_ token: String, for device: String) {
        let documentData = ["Token": token, "Device": device]
        tokenDatabase.document(device).setData(documentData, merge: true)
    }
    
    func retrieveTokens(completion: @escaping (Result<String, ErrorsManager>) -> Void) {
        tokenDatabase.getDocuments { (snapShot, error) in
            guard error == nil else {print("Error fetching device-tokens: \(error!.localizedDescription)"); return }
            _ = snapShot?.documents.map({ document in
                let device = document.documentID
                print("Device is \(device)")
                let documentContent = document.data()
                documentContent.forEach { (key, _) in
                    if let token = documentContent[key] as? String {
                        completion(.success(token))
                    } else {
                        completion(.failure(ErrorsManager.failedRetrievingTokens))
                    }
                }
            })
        }
    }
    
     //MARK: - Messages
    
    func upload(message: Message, from chatRoom: ChatRoom) {
        
        switch message.kind {
            
        case .photo, .video, .audio:
            print("Calling CloudStorage")
            cloudStorage.uploadAttachment(of: message, from: chatRoom) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    print("Errors while uploading file to CloudStorage: \(error.rawValue)")
                    message.messageDataURL = URL(string: error.rawValue)
                case .success(let url):
                    message.messageDataURL = url
                    self.cloudFirestoreUpload(message, messageContent: nil, from: chatRoom)
                }
            }
            
        case .text(let textContent):
            cloudFirestoreUpload(message, messageContent: textContent, from: chatRoom)
            
        case .emoji(let emojiString):
            cloudFirestoreUpload(message, messageContent: emojiString, from: chatRoom)
            
        case .attributedText(let attributedString):
            cloudFirestoreUpload(message, messageContent: attributedString.string, from: chatRoom)
            
        case .location(let location):
            let stringCoordinates = String(describing: location.location.coordinate)
            cloudFirestoreUpload(message, messageContent: stringCoordinates, from: chatRoom)
            
        case .contact(let contact):
            cloudFirestoreUpload(message, messageContent: contact.displayName, from: chatRoom)
            
        case .custom( _):
            cloudFirestoreUpload(message, messageContent: nil, from: chatRoom)
        }
    }
    
    private func cloudFirestoreUpload(_ message: Message, messageContent: String?, from chatRoom: ChatRoom) {
        let chatRoomReference = chatRooms.document(chatRoom.title).collection(Collection.chatMessages).document()
        let associatedDataURL = message.messageDataURL?.absoluteString ?? "No data associated with this message"
        let documentData: Dictionary<String, Any> = ["text": messageContent as Any,
                                                     "userName": message.user.displayName,
                                                     "userEmail": message.user.email,
                                                     "userPhotoURL": message.user.photoURL as Any,
                                                     "userProvider": message.user.provider as Any,
                                                     "messageID": message.messageId,
                                                     "Date": message.sentDate.timeIntervalSinceReferenceDate,
                                                     "messageDataURL": associatedDataURL]
        
        chatRoomReference.setData(documentData, merge: true)
    }
    
    
    func fetchMessages(for chatRoom: ChatRoom, requestedMostRecent: Bool = true, completion: @escaping (Result<Dictionary<ChatRoom, [Message]>, ErrorsManager>) -> Void) {
        var retrievedMessages = [Message]()
        let chatRoomMessages = chatRooms.document(chatRoom.title).collection(Collection.chatMessages)
        var temporaryImage: UIImage = UIImage()
        var databaseQuery: Query?
        
        if requestedMostRecent {
            databaseQuery = chatRoomMessages.order(by: "Date", descending: true).limit(to: 12)
        } else {
            if let lastSnapShot = lastSnapshotForChatRoom[chatRoom] {
                if let mostRecentSnapShot = lastSnapShot.last {
                    databaseQuery = chatRoomMessages.order(by: "Date", descending: true).limit(to: 25).start(afterDocument: mostRecentSnapShot)
                }
            }
        }
        
        databaseQuery?.addSnapshotListener(includeMetadataChanges: true) { (snapShot, error) in

            guard let snapShot = snapShot else { completion(.failure(ErrorsManager.failedFetchingMessages)); return }
            if snapShot.documents.count < 1 {
                if self.lastSnapshotForChatRoom[chatRoom] != nil {
                    self.lastSnapshotForChatRoom.removeValue(forKey: chatRoom)
                }
            } else {
                guard let latestSnapShot = snapShot.documents.last else { return }
                var snapShots: [QueryDocumentSnapshot] = []
                snapShots.append(latestSnapShot)
                self.lastSnapshotForChatRoom.updateValue(snapShots, forKey: chatRoom)
            }
            let hasPendingWrites = snapShot.metadata.hasPendingWrites
            if !hasPendingWrites { self.delegate?.shouldReloadMessages(mostRecent: requestedMostRecent) }
            let documents = snapShot.documents
            _ = documents.map { document in

                let text = document["text"] as? String
                let userName = document["userName"] as? String
                let userEmail = document["userEmail"] as? String
                let messageID = document["messageID"] as? String
                let timeInterval = document["Date"] as? TimeInterval
                let userPhotoURL = document["userPhotoURL"] as? URL
                let userProvider = document["userProvider"] as? String
                let resourceStringURL = document["messageDataURL"] as? String
                
                let user = User(name: userName ?? "Missing userName", email: userEmail ?? "Missing email address", photoURL: userPhotoURL, provider: userProvider)
                
                switch text {
                    case .some(let textContent):
                        let textMessage = Message(text: textContent, user: user, messageID: messageID ?? "No message ID", date: Date(timeIntervalSinceReferenceDate: timeInterval ?? 00))
                        guard !retrievedMessages.contains(textMessage) else { return }
                        retrievedMessages.insert(textMessage, at: 0)
                    case .none:
                        if let url = resourceStringURL {
                            if let resourceURL = URL(string: url) {
                                if let imageFromCache = self.cache.retrieveImage(withIdentifier: resourceURL.absoluteString) {
                                    temporaryImage = imageFromCache
                                }
                                else if let data = try? Data(contentsOf: resourceURL) {
                                    if let networkImage = UIImage(data: data) {
                                        temporaryImage = networkImage
                                        self.cache.saveImage(withIdentifier: resourceURL.absoluteString, image: networkImage)
                                    }
                                } else {
                                    let avasset = AVAsset(url: resourceURL)
                                    print("You've got an avAsset: \(avasset.commonMetadata)")
                                }
                            }
                        }
                    let messageWithImage = Message(image: temporaryImage, user: user, messageID: messageID ?? "no messageID", date: Date(timeIntervalSinceReferenceDate: timeInterval ?? 00))
                    guard !retrievedMessages.contains(messageWithImage) else { return }
                    retrievedMessages.insert(messageWithImage, at: 0)
                }
            }
            self.messagesForChatRoom.updateValue(retrievedMessages, forKey: chatRoom)
            completion(.success(self.messagesForChatRoom))
        }
    }
}

