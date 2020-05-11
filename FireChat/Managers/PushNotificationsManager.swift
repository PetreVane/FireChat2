//
//  PushNotificationsManager.swift
//  FireChat
//
//  Created by Petre Vane on 28/04/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

final class PushNotificationsManager {
    
    static let shared = PushNotificationsManager()
    private let firebaseStringURL = "https://fcm.googleapis.com/fcm/send"
    
    private init() { }
    
    func sendPushNotification(to token: String, title: String, body: String) {
        let firebaseURL = URL(string: firebaseStringURL)!
        let paramString: Dictionary<String, Any> = ["to" : token,
                                                    "notification" : ["title" : title, "body" : body],
                                                    "data" : ["user" : "test_id"]
        ]
        
        var request = URLRequest(url: firebaseURL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue(ProjectCredentials.serverKey, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request).resume()
    }

}

