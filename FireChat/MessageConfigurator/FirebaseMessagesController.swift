//
//  FirebaseMessagesController.swift
//  FireChat
//
//  Created by Petre Vane on 06/04/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class FirebaseMessagesController: MessagesViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    open lazy var audioController = AudioController(messageCollectionView: messagesCollectionView)
    let refreshController = UIRefreshControl()
    var messagesList = [Message]()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Testing MessageKit"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        audioController.stopAnyOngoingPlaying()
    }
}
