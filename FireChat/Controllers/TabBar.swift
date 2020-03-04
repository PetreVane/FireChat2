//
//  TabBar.swift
//  FireChat
//
//  Created by Petre Vane on 04/03/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit

class TabBar: UITabBarController {
    
    let channelVC = ChannelVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        channelVC.tabBarItem = UITabBarItem(title: "Channels", image: nil, tag: 0)
        viewControllers = [channelVC]
    }
    

}
