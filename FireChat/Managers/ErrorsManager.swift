//
//  ErrorsManager.swift
//  FireChat
//
//  Created by Petre Vane on 28/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import Foundation


enum ErrorsManager: String, Error {
    case failedAuthentication = "There were some problems signing you in."
    case failedFetchingChatRooms = "Failed fetching the list of available chat rooms"
    case failedDeletingChatRoom = "Chat room could not be deleted at this momment. Try again later!"
    case failedUploadingAudio = "Your audio file has not been uploaded to CloudStorage"
    case failedUploadingImage = "Your image file has not been uploaded to CloudStorage"
    case failedUploadingVideo = "Your video file has not been uploaded to CloudStorage"
    case failedFetchingMessages = "Unable to fetch your messages; make sure you're connected to internet and try again!"
    case failedRetrievingTokens = "Unable to retrieve device-tokens"
}
