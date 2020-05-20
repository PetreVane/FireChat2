//
//  GoogleSignInViewController.swift
//  FireChat
//
//  Created by Petre Vane on 06/05/2020.
//  Copyright © 2020 Petre Vane. All rights reserved.
//

import SwiftUI

struct ModalView: View {
    var body: some View {
        ZStack { LoadingState(animationName: "loadingCircle") }
            .frame(width: 50, height: 50, alignment: .center)
            .cornerRadius(20)
            .shadow(radius: 10)
    }
}

class GoogleSignInViewController_Previews: PreviewProvider {
    static var previews: some View {
        ModalView()
    }
}
