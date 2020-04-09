//
//  User.swift
//  FireChat
//
//  Created by Petre Vane on 28/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import Foundation
import MessageKit


struct User: SenderType, Equatable, Hashable {
    var senderId: String = ""
    var displayName: String
    let email: String
    let photoURL: URL?
    let provider: String?

    init(name: String, email: String, photoURL: URL?, provider: String?) {
        self.displayName = name
        self.email = email
        self.photoURL = photoURL
        self.provider = provider
    }
}

