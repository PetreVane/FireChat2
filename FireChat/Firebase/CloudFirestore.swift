//
//  CloudFirestore.swift
//  FireChat
//
//  Created by Petre Vane on 01/04/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit
import Firebase

class CloudFirestore {
    
    static let shared = CloudFirestore()
    private let database = Firestore.firestore()
    private let chatRooms = Firestore.firestore().collection(Collection.chatRooms)
    
    
    func fetchChatRooms(completion: @escaping (ChatRoom?, ErrorsManager?) -> Void) {

        chatRooms.getDocuments { (snapShot, error) in
            guard error == nil
                else { completion(nil, ErrorsManager.failedFetchingChannels); return }
            _ = snapShot?.documents.map({ (document) in
                
                let channelName = document.documentID
                let documentContent = document.data()
                
                documentContent.forEach { (key, _) in

                    if let channelDescription = documentContent[key] as? String {
                        let channel = ChatRoom(title: channelName, description: channelDescription)
                        completion(channel, nil)
                    } else { completion(nil, ErrorsManager.failedFetchingChannels) }
                }
            })
        }
    }
    
    func saveChatRoom(_ chatRoom: ChatRoom) {
        let documentTitle = chatRoom.title
        let documentData = ["Description": chatRoom.description]
        chatRooms.document(documentTitle).setData(documentData, merge: true)
    }
    
    func deleteChatRoom(_ channel: ChatRoom) {
        
    }
}

