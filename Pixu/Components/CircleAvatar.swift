//
//  Avatar.swift
//  Pixu
//
//  Created by Saul Martinez Diez on 15/1/26.
//

import SwiftUI

struct CircleAvatar: View {
    @Environment(AuthStatus.self) private var authStatus
    
    var body: some View {
        Circle()
            .fill(Color.clear)
            .overlay(
                Text(authStatus.initial)
                    .font(.title2)
                    .foregroundColor(.primary)
                    .bold()
            )
            .aspectRatio(1, contentMode: .fit)
            .frame(width: 32)
    }
}
#Preview(traits: .devEnvironment) {
    CircleAvatar()
}
