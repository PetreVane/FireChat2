//
//  CloudFirestore.swift
//  FireChat
//
//  Created by Petre Vane on 01/04/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit
import Firebase

final class CloudFirestore {
    
    static let shared = CloudFirestore()
    private let chatRooms = Firestore.firestore().collection(Collection.chatRooms)
    private let cloudStorage = CloudStorage.shared
    private let auth = FirebaseAuth.shared
    var lastSnapshotForChatRoom: Dictionary<ChatRoom, QueryDocumentSnapshot> = [:]
    var retrievedMessages = [Message]()
    
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
    
    
    func fetchLatestMessages(for chatRoom: ChatRoom, completion: @escaping (Result<[Message], ErrorsManager>) -> Void) {
        
        var databaseQuery: Query?
        
        let chatRoomMessages = chatRooms.document(chatRoom.title).collection(Collection.chatMessages)
        
        if let lastSnapShot = lastSnapshotForChatRoom[chatRoom] {
            print("There are some documents left")
            databaseQuery = chatRoomMessages.order(by: "Date", descending: false).limit(to: 1).start(afterDocument: lastSnapShot)
        } else {
            print("This must be the first read attempt")
            databaseQuery = chatRoomMessages.order(by: "Date", descending: false).limit(to: 1)
        }
        
        databaseQuery!.addSnapshotListener(includeMetadataChanges: true) { (snapShot, error) in

            guard let snapShot = snapShot else { completion(.failure(ErrorsManager.failedFetchingMessages)); return }
            guard let lastSnapShot = snapShot.documents.last else { return }
            self.lastSnapshotForChatRoom.updateValue(lastSnapShot, forKey: chatRoom)
            let documents = snapShot.documents
            print("Documents so far: \(documents.count)")
            _ = documents.map { document in

                let text = document["text"] as? String
                let userName = document["userName"] as? String
                let userEmail = document["userEmail"] as? String
                let messageID = document["messageID"] as? String
                let timeInterval = document["Date"] as? TimeInterval
                let userPhotoURL = document["userPhotoURL"] as? URL
                let userProvider = document["userProvider"] as? String
                let messageDataURL = document["messageDataURL"] as? URL

                let user = User(name: userName ?? "Missing userName", email: userEmail ?? "Missing email address", photoURL: userPhotoURL, provider: userProvider)
                let cloudMessage = Message(text: text ?? "No text", user: user, messageID: messageID ?? "No message ID", date: Date(timeIntervalSinceReferenceDate: timeInterval ?? 00))
                cloudMessage.messageDataURL = messageDataURL
                guard !self.retrievedMessages.contains(cloudMessage) else { return }
                self.retrievedMessages.insert(cloudMessage, at: 0)
                print("Retrieved messages: \(self.retrievedMessages.count)")
            }; completion(.success(self.retrievedMessages))
        }
    }
}

