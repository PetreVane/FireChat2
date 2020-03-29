//
//  Firebase.swift
//  FireChat
//
//  Created by Petre Vane on 27/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit
import Firebase


class Firebase {
    
    static let shared = Firebase()
    var users = [User]()
    
    func createUser(withUserName username: String, email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (createdUser, error) in
            
            guard self != nil else { return }
            guard error == nil else { return }
                        
            if let changeCredentialsRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                changeCredentialsRequest.displayName = username
                changeCredentialsRequest.commitChanges { (requestError) in
                    guard requestError == nil else { print("Error commiting user changes: \(requestError!.localizedDescription)"); return}
                }
            }
        }
    }
    
    func authenticateUser(withEmail email: String, password: String) {
                
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authUser, error) in
            guard let self = self else { return }
            guard error == nil else { ErrorsManager.failedAuthentication; return }
            
            guard let firebaseUser = authUser?.user else { return }
            let name = firebaseUser.displayName ?? "Missing name"
            let email = firebaseUser.email ?? "Missing email address"
            let photoURL = firebaseUser.photoURL
            let provider = firebaseUser.providerID
            let authenticatedUser = User(name: name, email: email, photoURL: photoURL, provider: provider)
            self.users.append(authenticatedUser)
        }
    }
}
