//
//  ErrorsManager.swift
//  FireChat
//
//  Created by Petre Vane on 28/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import Foundation


enum ErrorsManager: String, Error {
    case failedAuthentication = "There were some problems signing you in."
}
