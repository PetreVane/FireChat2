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
    private let database = Firestore.firestore()
    private let chatRooms = Firestore.firestore().collection(Collection.chatRooms)
    
    // Chat rooms
    func fetchChatRooms(completion: @escaping (ChatRoom?, ErrorsManager?) -> Void) {

        chatRooms.getDocuments { (snapShot, error) in
            guard error == nil
                else { completion(nil, ErrorsManager.failedFetchingChatRooms); return }
            _ = snapShot?.documents.map({ (document) in
                
                let channelName = document.documentID
                let documentContent = document.data()
                
                documentContent.forEach { (key, _) in

                    if let channelDescription = documentContent[key] as? String {
                        let channel = ChatRoom(title: channelName, description: channelDescription)
                        completion(channel, nil)
                    } else { completion(nil, ErrorsManager.failedFetchingChatRooms) }
                }
            })
        }
    }
    
    func saveChatRoom(_ chatRoom: ChatRoom) {
        let documentTitle = chatRoom.title
        let documentData = ["Description": chatRoom.description]
        chatRooms.document(documentTitle).setData(documentData, merge: true)
    }
    
    func deleteChatRoom(_ channel: ChatRoom, completion: @escaping (Bool, ErrorsManager?) -> Void) {
        chatRooms.document(channel.title).delete { (error) in
            guard error == nil else { completion(false, ErrorsManager.failedDeletingChatRoom); return }
            completion(true, nil)
        }
    }
    
    //Messages
    func uploadMessage(to chatRoom: ChatRoom, message: Message) {
        
        switch message.kind {
            case .photo, .audio, .location, .video:
                print("Calling CloudStorage")
            case .text(let textContent):
                cloudFirebaseUpload(message: message, messageContent: textContent, to: chatRoom)
            default:
                print("Default statement Switch case uploadMessage CloudFirestore")
        }
    }
    
    private func cloudFirebaseUpload(message: Message, messageContent: String, to chatRoom: ChatRoom) {
        let chatRoomReference = chatRooms.document(chatRoom.title).collection(Collection.chatMessages).document()
        let associatedDataURL = message.messageDataURL?.absoluteString ?? ""
        
        let documentData: Dictionary<String, Any> = ["Sender": message.sender,
                                                     "Date": message.sentDate,
                                                     "MessageID": message.messageId,
                                                     "MessageTextContent": messageContent,
                                                     "MessageAsociatedDataURL": associatedDataURL]
        
        chatRoomReference.setData(documentData, merge: true)
    }
}

