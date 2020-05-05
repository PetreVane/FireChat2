//
//  ChannelsViewController.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

protocol ChannelsVCDelegate: AnyObject {
    func didPressChatRoom(_ chatRoom: ChatRoom)
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
        configureTableView()
        addBarButton()
        welcomeMessage()
        title = "Channels View Controller"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchChatRooms()
    }
    
    //MARK: - Visual elements
    private func welcomeMessage() {
        guard let firebaseUser = firebase.loggedInUser.first else { return }
        DispatchQueue.main.async {
            self.presentAlert(withTitle: "Welcome \(firebaseUser.displayName)", message: "It's nice to have you on board!", buttonTitle: "Okay 👍🏻")
        }
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
        cloudDatabase.fetchChatRooms { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.presentAlert(withTitle: "What? An Error?!", message: error.rawValue , buttonTitle: "Dismiss")
            case .success(let chatRoom):
                guard !self.chatRooms.contains(chatRoom) else { return }
                self.chatRooms.append(chatRoom)
                self.chatRooms.count == 0 ? self.showMissingChatRooms() : self.tableView.reloadData()
                DispatchQueue.main.async { self.view.bringSubviewToFront(self.tableView) }
            }
        }
    }
    
    private func createChatRoom(_ chatRoom: ChatRoom) {
        cloudDatabase.createChatRoom(chatRoom)
    }
    
    private func deleteChatRoom(_ chatRoom: ChatRoom) {
        cloudDatabase.deleteChatRoom(chatRoom) { completion in
            
            switch completion {
                
            case .failure(let error):
                self.presentAlert(withTitle: "What, an Error!?", message: "\(error.rawValue)", buttonTitle: "I'll try later")
                
            case .success:
                self.presentAlert(withTitle: "Success", message: "\(chatRoom.title) has been deleted", buttonTitle: "Nicely done 👍🏻")
                self.tableView.reloadData()
            }
        }
    }
}

extension ChannelsViewController: AlertControllerDelegate {
    func didCreateNewChatRoom(_ newChatRoom: ChatRoom) {
        createChatRoom(newChatRoom)
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
        cell.selectionStyle = .none
        let chatRoom = chatRooms[indexPath.row]
        cell.titleLabel.text = chatRoom.title
        cell.channelDescription.text = chatRoom.description
        return cell
    }
}

//MARK: - TableView delegate
extension ChannelsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let tappedChatRoom = chatRooms[indexPath.row]
        delegate?.didPressChatRoom(tappedChatRoom)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let selectedChatRoom = chatRooms[indexPath.row]
        if editingStyle == .delete {
            chatRooms.remove(at: indexPath.row)
            deleteChatRoom(selectedChatRoom)
        }
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

