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
    var loggedInUser: Set<User> = []
    typealias handler = ((Bool, String) -> Void)
    
    private init() { }
    
    //MARK: TO DO [Replace handler parameters types with Result<Bool, Error> type]
    
    func createUser(withUserName username: String, email: String, password: String, completion: @escaping handler) {
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (createdUser, error) in
            
            guard let self = self else { return }
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
                self.loggedInUser.insert(recentlyCreatedUser)
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
            self.loggedInUser.insert(authenticatedUser)
            completion(true, "Success")
        }
    }
    
    func authenticateUser(with oathCredential: OAuthCredential, fullName: String?, completion: @escaping (Result<Bool, ErrorsManager>) ->Void) {
        
        Auth.auth().signIn(with: oathCredential) { [weak self] (authUser, error) in
            guard self != nil else { return }
            guard error == nil else { completion(.failure(ErrorsManager.failedAuthentication)); return }
            
            if let changeCredentialsRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                changeCredentialsRequest.displayName = fullName
                changeCredentialsRequest.commitChanges { (requestError) in
                    guard requestError == nil else { completion(.failure(ErrorsManager.failedUpdatingUserDetails)); return }
                }; completion(.success(true))
            }
        }
    }
    
    func checkIfSignedIn(completion: @escaping (Bool) -> Void) {

        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let authenticatedUser = user {
                guard
                    let name = authenticatedUser.displayName,
                    let email = authenticatedUser.email
                else { return }

                let provider = authenticatedUser.providerID
                let photoURL = authenticatedUser.photoURL
                let currentUser = User(name: name, email: email, photoURL: photoURL, provider: provider)
                self.loggedInUser.insert(currentUser)
                completion(true)
            }
        }
    }
    
    func signOut() {
        let firebaseAuthentication = Auth.auth()
        do { try firebaseAuthentication.signOut() }
        catch { print("Errors while signing out: \(error.localizedDescription)") }
        loggedInUser.removeAll()
    }
    
    func sendPasswordResetLink(to emailAddress: String, completion: @escaping handler) {
        Auth.auth().sendPasswordReset(withEmail: emailAddress) { (error) in
            
            guard error == nil else { completion(false, error!.localizedDescription); return }
            completion(true,"Password reset link sent to \(emailAddress).")
        }
    }
}
