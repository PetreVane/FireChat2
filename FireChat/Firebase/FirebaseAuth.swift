//
//  FirebaseAuth.swift
//  FireChat
//
//  Created by Petre Vane on 27/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit
import Firebase


final class FirebaseAuth {
    
    static let shared = FirebaseAuth()
    var users = [User]()
    typealias handler = ((Bool, String) -> Void)
    
    func createUser(withUserName username: String, email: String, password: String, completion: @escaping handler) {
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (createdUser, error) in
            
            guard self != nil else { return }
            guard error == nil else { completion(false, error!.localizedDescription); return }
                        
            if let changeCredentialsRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                changeCredentialsRequest.displayName = username
                changeCredentialsRequest.commitChanges { (requestError) in
                    guard requestError == nil else { completion(false, "User account created; updates could not be commited"); return }
                }; completion(true, "Success saving user credentials")
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
            guard error == nil else { completion(false, error!.localizedDescription); return }
            
            guard let firebaseUser = authUser?.user else { return }
            let name = firebaseUser.displayName ?? "Stranger"
            let email = firebaseUser.email ?? "Email not specified"
            let photoURL = firebaseUser.photoURL
            let provider = firebaseUser.providerID
            let authenticatedUser = User(name: name, email: email, photoURL: photoURL, provider: provider)
            self.users.append(authenticatedUser)
            completion(true, "Success")
        }
    }
    
    func checkIfSignedIn(completion: @escaping (Bool) -> Void) {
        
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil { completion(true) }
            else { completion(false) }
        }
    }
    
    func signOut() {
        let firebaseAuthentication = Auth.auth()
        do { try firebaseAuthentication.signOut() }
        catch { print("Errors while signing out: \(error.localizedDescription)") }
    }
    
    func sendPasswordResetLink(to emailAddress: String, completion: @escaping handler) {
        Auth.auth().sendPasswordReset(withEmail: emailAddress) { (error) in
            
            guard error == nil else { completion(false, error!.localizedDescription); return }
            completion(true,"Password reset link sent to \(emailAddress).")
        }
    }
}
