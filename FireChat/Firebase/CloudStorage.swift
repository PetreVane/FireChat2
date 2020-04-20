//
//  CloudStorage.swift
//  FireChat
//
//  Created by Petre Vane on 07/04/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit
import Firebase
import MessageKit

final class CloudStorage {
    
    static let shared = CloudStorage()
    private let databaseReference = Storage.storage().reference()
    private let metaData = StorageMetadata()
    
    func createStorage(forChatRoom chatRoom: ChatRoom, completion: @escaping(Result<URL, ErrorsManager>) -> Void) {
        let title = chatRoom.title
        let date = Date()
        print("Your date is \(date)")
        metaData.contentType = "image/png"
        let directoryReference = databaseReference.child("\(title)/\(CloudStorageDirectory.images)/Some Picture")
        
        if let imageData = Images.noMessages.pngData() {
            _ = directoryReference.putData(imageData, metadata: metaData) { (metadata, error) in

                guard error == nil else { completion(.failure(ErrorsManager.failedUploadingImage)); return }
                directoryReference.downloadURL { (url, error) in
                    guard error == nil else { return }
                    guard let downloadURL = url else { return }
                    print("Your image url is \(downloadURL.absoluteString)")
                    completion(.success(downloadURL))
                }
            }
        }
    }
    
    func uploadAttachment(of message: Message, from chatRoom: ChatRoom, completion: @escaping (Result<URL, ErrorsManager>) -> Void) {
        
        let chatRoomTitle = chatRoom.title
        let timeStamp = Date()
        
        switch message.kind {
        case .audio(let audioItem):
            metaData.contentType = "audio/wav/mp3"
            let audioDirectory = databaseReference.child("\(chatRoomTitle)/\(CloudStorageDirectory.audioFiles)/\(timeStamp)")
            let audioURL = audioItem.url
            audioDirectory.putFile(from: audioURL, metadata: metaData) { (metadata, error) in
                guard error == nil else { completion(.failure(ErrorsManager.failedUploadingAudio)); return }
                audioDirectory.downloadURL { (url, error) in
                    guard error == nil else { completion(.failure(ErrorsManager.failedUploadingAudio)); return }
                    guard let downloadURL = url else { return }
                    completion(.success(downloadURL))
                }
            }

        case .photo(let mediaItem):
            metaData.contentType = "image/jpg/png"
            let imageDirectory = databaseReference.child("\(chatRoomTitle)/\(CloudStorageDirectory.images)/\(timeStamp)")
            guard let image = mediaItem.image else { return }
            if let imageData = image.pngData() {
                imageDirectory.putData(imageData, metadata: metaData) { (metadata, error) in
                    guard error == nil else { completion(.failure(ErrorsManager.failedUploadingImage)); return }
                    imageDirectory.downloadURL { (url, error) in
                        guard error == nil else {completion(.failure(ErrorsManager.failedUploadingImage)); return }
                        guard let imageURL = url else { return }
                        completion(.success(imageURL))
                    }
                }
            }
        
        case .video(let videoItem):
            metaData.contentType = "video/avi"
            let videoDirectory = databaseReference.child("\(chatRoomTitle)/\(CloudStorageDirectory.videos)/\(timeStamp)")
            guard let videoURL = videoItem.url else { return }
            videoDirectory.putFile(from: videoURL, metadata: metaData) { (metadata, error) in
                guard error == nil else { completion(.failure(ErrorsManager.failedUploadingVideo)); return }
                videoDirectory.downloadURL { (url, error) in
                    guard error == nil else {completion(.failure(ErrorsManager.failedUploadingVideo)); return }
                    guard let videoURL = url else { return }
                    completion(.success(videoURL))
                }
            }
        default:
            print("Unrecognized file type")
        }
    }
}
