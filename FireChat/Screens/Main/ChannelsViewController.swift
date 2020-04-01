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
    private var channels = [Channel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        welcomeMessage()
        configureTableView()
        fetchChatRooms()
    }
        
    private func welcomeMessage() {
        guard let firebaseUser = firebase.users.last else { return }
        presentAlert(withTitle: "Welcome \(firebaseUser.name)", message: "It's nice to have you on board!", buttonTitle: "Okay 👍🏻")
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
    
    //MARK: - Firebase
    
    func fetchChatRooms() {
        cloudDatabase.fetchChannels { [weak self] (channel, error) in
            guard let self = self else { return }
            guard error == nil
                else { self.presentAlert(withTitle: "What? An Error?!", message: error!.rawValue , buttonTitle: "Dismiss")
                return }
            if let firebaseChannel = channel {
                self.channels.append(firebaseChannel)
                self.tableView.reloadData()
            }
        }
    }
}

extension ChannelsViewController {
    class func instantiate(delegate: ChannelsVCDelegate) -> ChannelsViewController {
        let viewController = ChannelsViewController()
        viewController.delegate = delegate
        return viewController
    }
}

extension ChannelsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelCell.identifier, for: indexPath) as? ChannelCell
              else { return UITableViewCell() }
        let currentChannel = channels[indexPath.row]
        cell.titleLabel.text = currentChannel.title
        cell.channelDescription.text = currentChannel.description
        
        return cell
    }
}

extension ChannelsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //    private let label = FireLabel(textAlignment: .center, fontSize: 25)
    //    private func configureLabel() {
    //        view.addSubview(label)
    //        label.text = "Welcome to Channels ViewController"
    //        let padding: CGFloat = 50
    //        label.backgroundColor = .systemBackground
    //
    //        NSLayoutConstraint.activate([
    //
    //            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
    //            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
    //            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
    //            label.heightAnchor.constraint(equalToConstant: padding)
    //        ])
    //    }
}

