//
//  User.swift
//  FireChat
//
//  Created by Petre Vane on 28/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import Foundation


struct User {
    let name: String
    let email: String
    let photoURL: URL?
    let provider: String?

    init(name: String, email: String, photoURL: URL?, provider: String?) {
        self.name = name
        self.email = email
        self.photoURL = photoURL
        self.provider = provider
    }
}
