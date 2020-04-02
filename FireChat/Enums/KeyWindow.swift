//
//  KeyWindow.swift
//  FireChat
//
//  Created by Petre Vane on 02/04/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

enum KeyWindow {
    static let rootViewController = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive})
    .map({$0 as? UIWindowScene})
    .compactMap({$0})
    .first?.windows
    .filter({$0.isKeyWindow}).first?.rootViewController
}
