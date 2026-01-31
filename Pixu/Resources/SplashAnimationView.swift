//
//  SplashAnimationView.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 26/1/26.
//

import SwiftUI

struct SplashAnimationView: View {

    @State private var isBreathing = false

    var body: some View {
        Image(.pixieHi)
            .resizable()
            .scaledToFit()
            .frame(width: 350, height: 350)
            .globalBackground()
    }
}

#Preview {
    SplashAnimationView()
}
