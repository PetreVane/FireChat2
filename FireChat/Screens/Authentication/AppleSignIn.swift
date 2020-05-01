//
//  AppleSignIn.swift
//  FireChat
//
//  Created by Petre Vane on 29/04/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit
import AuthenticationServices

protocol AppleSignInDelegate: AnyObject {
    func didCompleteAppleAuthorization()
}

class AppleSignInViewController: UIViewController {
    
    weak var delegate: AppleSignInDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performExistingAccountSetupFlows()
    }
    
    
    // - Tag: perform_appleid_password_request
    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    /// - Tag: perform_appleid_request
    @objc func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension AppleSignInViewController: ASAuthorizationControllerDelegate {
    
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("UserIdentifier: \(userIdentifier)")
            print("Full Name: \(String(describing: fullName))")
            print("Email address: \(String(describing: email))")
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
//            self.saveUserInKeychain(userIdentifier)
            
            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
//            self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
        
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            print("Username: \(username) and password: \(password)")
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
//                self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
     }
    
}

extension AppleSignInViewController: ASAuthorizationControllerPresentationContextProviding {
     /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension AppleSignInViewController {
    class func instantiate(delegate: AppleSignInDelegate) -> AppleSignInViewController {
        
    }
}
