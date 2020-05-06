//
//  LoadingState.swift
//  FireChat
//
//  Created by Petre Vane on 05/05/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import UIKit
import Lottie

class LoadingState: UIView {
    
    private let loadingCircle = AnimationView(name: "loadingCircle")
    private let animatedLock = AnimationView(name: "animatedLock")
    private let cubeLoading = AnimationView(name: "cubeLoading")
    private let isometricCube = AnimationView(name: "isometricCube")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAnimationView(animationView: loadingCircle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAnimationView(animationView: AnimationView) {
        addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
        
            animationView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 305),
            animationView.heightAnchor.constraint(equalToConstant: 305)
        ])
    }
    
    
    func playLoadingAnimation() {
        loadingCircle.play()
    }
    
    func stopPlayingLoadingAnimation() {
        loadingCircle.stop()
    }
}
