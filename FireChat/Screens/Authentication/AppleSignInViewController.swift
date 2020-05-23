//
//  AppleSignIn.swift
//  FireChat
//
//  Created by Petre Vane on 29/04/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit
import Firebase
import AuthenticationServices
import CryptoKit


protocol AppleSignInDelegate: AnyObject {
    func didCompleteAppleAuthorization()
    func didCompleteAppleAuthorizationWithError()
}

class AppleSignInViewController: UIViewController {
    
    weak var delegate: AppleSignInDelegate?
    let firebaseAuthentication = FirebaseAuth.shared
    let userDefaults = UserDefaults.standard
    var currentNonce: String?
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
    private func performAccountSetupFlows() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        
        // request full name and email from the user's Apple ID
        request.requestedScopes = [.fullName, .email]
        
        // Generate nonce for validation after authentication successful
        self.currentNonce = randomNonceString()
        // Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest
        request.nonce = sha256(currentNonce!)
        
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
    
    
    /// - Tag: perform_appleid_request
    @objc func handleAuthorizationAppleIDButtonPress() {
       performAccountSetupFlows()
    }
}

extension AppleSignInViewController: ASAuthorizationControllerDelegate {
    
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential: authenticateWithAppleID(appleIDCredential)
            default: break
        }
     }
    
    private func authenticateWithAppleID(_ appleIDCredential: ASAuthorizationAppleIDCredential) {
        // Create an account in your system.
        let userIdentifier = appleIDCredential.user
        
        // Save authorised user ID for future reference
        self.userDefaults.set(userIdentifier, forKey: "appleUserIdentifier")
        let fullName = appleIDCredential.fullName?.description
        
        // Retrieve the secure nonce generated during Apple sign in
        guard let nonce = self.currentNonce else { fatalError("Invalid state: A login callback was received, but no login request was sent.") }

        // Retrieve Apple identity token
        guard let appleIDToken = appleIDCredential.identityToken else { print("Failed to fetch identity token"); return }

        // Convert Apple identity token to string
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else { print("Failed to decode identity token"); return }

        // Initialize a Firebase credential using secure nonce and Apple identity token
        let appleCredentials = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
        firebaseAuthentication.authenticateUser(with: appleCredentials, fullName: fullName) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
                case .success(_): self.delegate?.didCompleteAppleAuthorization()
                case .failure(_): self.delegate?.didCompleteAppleAuthorizationWithError()
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authorization completed with error: \(error.localizedDescription)")
        guard let error = error as? ASAuthorizationError else { return }
        switch error.code {
            case .canceled: print("User cancelled authentication")
            case .unknown: print("Unknown error")
            case .invalidResponse: print("Invalid response/ forgotten password?")
            case .notHandled: print("Unknown error / internet connection issue? ")
            case .failed: print("Failure when trying to authenticate")
            @unknown default: print("Default case")
        }
        
        delegate?.didCompleteAppleAuthorizationWithError()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 { return }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
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
        let viewController = AppleSignInViewController()
        viewController.delegate = delegate
        return viewController
    }
}
