//
//  AnimationsManager.swift
//  FireChat
//
//  Created by Petre Vane on 03/05/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit
import Lottie

struct AnimationManager {
    let successCase = "success"
    
    func showSuccess(inView view: UIView) {
        let successAnimation = Animation.named(successCase)
        // Load animation to AnimationView
        let animationView = AnimationView(animation: successAnimation)
        animationView.frame = CGRect(x: 150, y: 150, width: 100, height: 100)
        view.addSubview(animationView)
        animationView.play()
    }
}
