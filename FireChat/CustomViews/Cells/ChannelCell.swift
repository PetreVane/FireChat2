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
    var titleLabel = FireLabel(textAlignment: .center, fontSize: 10)
    
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
        let padding: CGFloat = 10
        accessoryType = .disclosureIndicator
        
        NSLayoutConstraint.activate([
        
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        layoutIfNeeded()
    }
}
