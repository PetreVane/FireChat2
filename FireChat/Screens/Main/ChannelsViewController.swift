//
//  ChannelsViewController.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

protocol ChannelsVCDelegate: AnyObject {
    // didPressChatCell -> init ChatVC
}


class ChannelsViewController: UIViewController {
    
    weak var delegate: ChannelsVCDelegate?
    private let firebase = FirebaseAuth.shared
    private let cloudDatabase = CloudFirestore.shared
    private let tableView = UITableView()
    private var chatRooms = [ChatRoom]()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addBarButton()
        welcomeMessage()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchChatRooms()
    }
    
    //MARK: - Visual elements
    private func welcomeMessage() {
        guard let firebaseUser = firebase.users.last else { return }
        presentAlert(withTitle: "Welcome \(firebaseUser.name)", message: "It's nice to have you on board!", buttonTitle: "Okay 👍🏻")
    }
    
    private func showMissingChatRooms() {
        showEmptyState(withTitle: "No chat rooms yet", message: "Press '+' button to add one, now!")
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        let padding: CGFloat = 10
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChannelCell.self, forCellReuseIdentifier: ChannelCell.identifier)
        tableView.removeEmptyCells()
        
        NSLayoutConstraint.activate([
        
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding * 2),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
    }
    
    private func addBarButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonPressed))
//        let addButton = UIBarButtonItem(title: "Add chat room", style: .plain, target: self, action: #selector(barButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func barButtonPressed() {
        presentActionAlertController(delegate: self)
    }
    
    
    //MARK: - Firebase
   private func fetchChatRooms() {
        cloudDatabase.fetchChatRooms { [weak self] (cloudChatRoom, error) in
            guard let self = self else { return }
            guard error == nil else {
                self.presentAlert(withTitle: "What? An Error?!", message: error!.rawValue , buttonTitle: "Dismiss"); return }
            if let chatRoom = cloudChatRoom {
                guard !self.chatRooms.contains(chatRoom) else { return }
                self.chatRooms.append(chatRoom)
                self.chatRooms.count == 0 ? self.showMissingChatRooms() : self.tableView.reloadData()
            }
        }
    }
    
    private func saveChannelToCloud(_ channel: ChatRoom) {
        cloudDatabase.saveChatRoom(channel)
    }
}

extension ChannelsViewController: AlertControllerDelegate {
    func didCreateNewChatRoom(_ chatRoom: ChatRoom) {
        saveChannelToCloud(chatRoom)
        fetchChatRooms()
    }
}

//MARK: - TableView data source
extension ChannelsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelCell.identifier, for: indexPath) as? ChannelCell
              else { return UITableViewCell() }
        let chatRoom = chatRooms[indexPath.row]
        cell.titleLabel.text = chatRoom.title
        cell.channelDescription.text = chatRoom.description
        return cell
    }
}

//MARK: - TableView delegate
extension ChannelsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: - Initialisation
extension ChannelsViewController {
    class func instantiate(delegate: ChannelsVCDelegate) -> ChannelsViewController {
        let viewController = ChannelsViewController()
        viewController.delegate = delegate
        return viewController
    }
}

