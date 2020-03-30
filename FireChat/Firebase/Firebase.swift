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
    typealias handler = ((Bool, String?) -> Void)
    
    func createUser(withUserName username: String, email: String, password: String, completion: @escaping handler) {
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (createdUser, error) in
            
            guard self != nil else { return }
            guard error == nil else { completion(false, error?.localizedDescription); return }
                        
            if let changeCredentialsRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                changeCredentialsRequest.displayName = username
                changeCredentialsRequest.commitChanges { (requestError) in
                    guard requestError == nil else { completion(false, "User account created; updates could not be commited"); return }
                }; completion(true, nil)
            }
            if let newUser = createdUser?.user {
                let name = newUser.displayName ?? "Stranger"
                let email = newUser.email ?? "Email not specified"
                let photoURL = newUser.photoURL
                let provider = newUser.providerID
                let recentlyCreatedUser = User(name: name, email: email, photoURL: photoURL, provider: provider)
                self?.users.append(recentlyCreatedUser)
            }
        }
    }
    
    func authenticateUser(withEmail email: String, password: String, completion: @escaping handler) {
                
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authUser, error) in
            guard let self = self else { return }
            guard
                error == nil
                else {
                    completion(false, error?.localizedDescription)
                    return
                }
            
            guard let firebaseUser = authUser?.user else { return }
            let name = firebaseUser.displayName ?? "Stranger"
            let email = firebaseUser.email ?? "Email not specified"
            let photoURL = firebaseUser.photoURL
            let provider = firebaseUser.providerID
            let authenticatedUser = User(name: name, email: email, photoURL: photoURL, provider: provider)
            self.users.append(authenticatedUser)
            completion(true, nil)
        }
    }
    
    func getSignedInUser(completion: @escaping (User?) -> Void) {
        
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if let user = user {
                let signedInUser = User(name: user.displayName ?? "Missing name", email: user.email ?? "Missing email", photoURL: user.photoURL, provider: user.providerID)
                completion(signedInUser)
            } else { completion(nil) }
        }
    }
    
    func signOut() {
        let firebaseAuthentication = Auth.auth()
        do {
            try firebaseAuthentication.signOut()
            print("Success signing out")
        } catch {
            print("Errors while signing out: \(error.localizedDescription)")
        }
    }
}
