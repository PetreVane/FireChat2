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
    func didCompleteAppleAuthorizationWithError()
}

class AppleSignInViewController: UIViewController {
    
    weak var delegate: AppleSignInDelegate?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        handleAuthorizationAppleIDButtonPress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Private methods
 
    // - Tag: perform_appleid_password_request
    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
    private func performExistingAccountSetupFlows() {
        print("Called performExistingAccountSetupFlows ...")
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
        
        // request full name and email from the user's Apple ID
        request.requestedScopes = [.fullName, .email]
        
        // pass the request to the initializer of the controller
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        // similar to delegate, this will ask the view controller
        // which window to present the ASAuthorizationController
        authorizationController.presentationContextProvider = self
     
        // delegate functions will be called when user data is
        // successfully retrieved or error occured
        authorizationController.delegate = self
        
        // show the Sign-in with Apple dialog
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
            
            case let passwordCredential as ASPasswordCredential:
        
                // Sign in using an existing iCloud Keychain credential.
                let username = passwordCredential.user
                let password = passwordCredential.password
                print("Username: \(username) and password: \(password)")
                
                // Pass credentials to Firebase
                DispatchQueue.main.async { }
        default:
            break
        }
     }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authorization completed with error: \(error.localizedDescription)")
        delegate?.didCompleteAppleAuthorizationWithError()
    }
    
//    private func saveUserInKeychain(_ userIdentifier: String) {
//        do {
//            try KeychainItem(service: "com.example.apple-samplecode.juice", account: "userIdentifier").saveItem(userIdentifier)
//        } catch {
//            print("Unable to save userIdentifier to keychain.")
//        }
//    }
    
}

extension AppleSignInViewController: ASAuthorizationControllerPresentationContextProviding {
     /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension AppleSignInViewController {
    class func instantiate(delegate: AppleSignInDelegate) -> AppleSignInViewController {
        let viewController = AppleSignInViewController()
        viewController.delegate = delegate
        return viewController
    }
}
