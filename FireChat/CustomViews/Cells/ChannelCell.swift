//
//  ChannelCell.swift
//  FireChat
//
//  Created by Petre Vane on 30/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    static let identifier = "ChannelCell"
    let titleLabel = FireLabel(textAlignment: .left, fontSize: 20)
    let channelDescription = FireLabel(textAlignment: .left, fontSize: 18)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureCell() {
        addSubview(titleLabel)
        addSubview(channelDescription)
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .systemOrange
        channelDescription.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        let padding: CGFloat = 18
        accessoryType = .disclosureIndicator
        
        NSLayoutConstraint.activate([
        
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            
            channelDescription.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            channelDescription.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            channelDescription.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            channelDescription.heightAnchor.constraint(equalToConstant: 22)
        ])
        layoutIfNeeded()
    }
}
