//
//  LoadingState.swift
//  FireChat
//
//  Created by Petre Vane on 05/05/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import SwiftUI
import Lottie

struct LoadingState: UIViewRepresentable {

    let animationView = AnimationView()
    var fileName: String

    init(animationName: String) {
        self.fileName = animationName
    }
    
    private let loadingCircle = AnimationView(name: "loadingCircle")
    private let animatedLock = AnimationView(name: "animatedLock")
    private let cubeLoading = AnimationView(name: "cubeLoading")
    private let isometricCube = AnimationView(name: "isometricCube")

    func playLoadingAnimation() {
        loadingCircle.play()
    }

    func stopPlayingLoadingAnimation() {
        loadingCircle.stop()
    }
    
        func makeUIView(context: UIViewRepresentableContext<LoadingState>) -> some UIView {
            let view = UIView()
            animationView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(animationView)
    
            let widthAnchor = animationView.widthAnchor.constraint(equalTo: view.heightAnchor)
            let heightAnchor = animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
            NSLayoutConstraint.activate([widthAnchor, heightAnchor])
    
            let animation = Animation.named(fileName)
            animationView.animation = animation
            animationView.contentMode = .scaleAspectFit
            animationView.play()
            return view
        }
    
    
        func updateUIView(_ uiView: UIViewType, context: Context) { }
}

